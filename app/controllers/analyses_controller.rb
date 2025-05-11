class AnalysesController < ApplicationController
  
  def new
  end

  def create
    @analysis = Analysis.new(analyses_params)
    if @analysis.save
      redirect_path = analysis_path(@analysis)
      render json: { message: "succes", redirect_path: } status: :ok
    end
  end

  private

  def analyses_params
    params.require(:analysis).permit(:name, :type, :project_id)
  end
end