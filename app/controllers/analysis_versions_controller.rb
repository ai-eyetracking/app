class AnalysisVersionsController < ApplicationController
  before_action :set_analysis
  before_action :set_version, only: [:show]
  
  def index
    @versions = @analysis.versions.ordered
    render json: @versions
  end
  
  def show
    render json: @version
  end
  
  def create
    @version = @analysis.versions.build(version_params)
    
    if params[:image].present?
      # Handle image upload
      uploaded_file = params[:image]
      
      # Create directory structure
      dir_path = Rails.root.join('storage', 'projects', @analysis.project_id.to_s, 'analyses', @analysis.id.to_s, 'versions')
      FileUtils.mkdir_p(dir_path)
      
      # Generate filename with version number
      filename = "v#{@version.version_number}_#{uploaded_file.original_filename}"
      file_path = dir_path.join(filename)
      
      # Save file
      File.open(file_path, 'wb') do |file|
        file.write(uploaded_file.read)
      end
      
      # Store relative path
      @version.image_path = "storage/projects/#{@analysis.project_id}/analyses/#{@analysis.id}/versions/#{filename}"
    end
    
    if @version.save
      render json: { 
        message: "Version created successfully", 
        version: @version,
        redirect_path: analysis_path(@analysis)
      }, status: :created
    else
      render json: { errors: @version.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_analysis
    @analysis = Analysis.find(params[:analysis_id])
  end
  
  def set_version
    @version = @analysis.versions.find(params[:id])
  end
  
  def version_params
    params.permit(:notes)
  end
end
