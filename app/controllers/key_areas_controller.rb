class KeyAreasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_analysis
  before_action :set_key_area, only: [:destroy]

  def index
    @key_areas = @analysis.key_areas
    render json: @key_areas
  end

  def create
    @key_area = @analysis.key_areas.build(key_area_params)
    
    if @key_area.save
      render json: @key_area, status: :created
    else
      render json: { errors: @key_area.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def bulk_update
    # Receive all key areas and update them in one go
    key_areas_data = params[:key_areas] || []
    
    # Delete existing key areas and recreate them
    @analysis.key_areas.destroy_all
    
    created_areas = []
    key_areas_data.each do |area_data|
      key_area = @analysis.key_areas.build(
        name: area_data[:name],
        x: area_data[:x],
        y: area_data[:y],
        width: area_data[:width],
        height: area_data[:height]
      )
      
      if key_area.save
        created_areas << key_area
      else
        render json: { errors: key_area.errors.full_messages }, status: :unprocessable_entity
        return
      end
    end
    
    render json: created_areas
  end

  def destroy
    @key_area.destroy
    head :no_content
  end

  # Get common labels for the UI
  def labels
    render json: { 
      common_labels: KeyArea::COMMON_LABELS,
      user_labels: current_user_labels
    }
  end

  private

  def set_analysis
    @analysis = current_user.projects
                           .joins(:analyses)
                           .find_by!(analyses: { id: params[:analysis_id] })
                           .analyses
                           .find(params[:analysis_id])
  end

  def set_key_area
    @key_area = @analysis.key_areas.find(params[:id])
  end

  def key_area_params
    params.require(:key_area).permit(:name, :x, :y, :width, :height)
  end

  def current_user_labels
    # Get unique labels used by the current user across all their analyses
    current_user.projects
                .joins(analyses: :key_areas)
                .pluck('DISTINCT key_areas.name')
                .reject { |name| KeyArea::COMMON_LABELS.include?(name) }
                .sort
  end
end