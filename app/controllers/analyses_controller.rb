class AnalysesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_analysis, only: [:show]
  
  def new
  end
  
  def show
    @versions = @analysis.versions.ordered
  end

  def create
    @analysis = Analysis.new(analyses_params)
    if @analysis.save
      redirect_path = analysis_path(@analysis)
      render json: { message: "success", redirect_path: }, status: :ok
    else
      render json: { errors: @analysis.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  
  def set_analysis
    @analysis = Analysis.find(params[:id])
  end

  def analyses_params
    params.require(:analysis).permit(:name, :analysis_type, :project_id)
  end
end