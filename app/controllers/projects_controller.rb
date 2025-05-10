class ProjectsController < ApplicationController
  
  def index
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
    if @project.save
      redirect_to @project, notice: "Project was sucessfuly created"
    else
      render :new
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description)
  end
end