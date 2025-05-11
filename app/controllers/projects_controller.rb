class ProjectsController < ApplicationController
  before_action :set_project, only: [:show]
  
  def index
    @project = Project.last

    if @project
      redirect_to(@project)
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
    if @project.save
      redirect_path = project_path(@project)
      render json: { message: "#{@project.title} generated", redirect_path: }, status: :ok
    else
      render json: { 
        error: "Failed to create project", 
        errors: @project.errors.full_messages,
        details: @project.errors.details
      }, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def project_params
    params.require(:project).permit(:title, :description)
  end

  def set_project
    @porduct = Project.find(params[:id])
  end
end