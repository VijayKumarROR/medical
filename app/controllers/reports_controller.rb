class ReportsController < ApplicationController
	before_action :set_patient, only: [:show]
	before_action :set_report, only: [:edit,:update,:destroy]
  
  def index
  end

  def new
  end

  def edit
  end

  def show
  end

  def update
  	if @report.update_attributes(report_params)
  		flash[:notice] = "Report has been updated"
  		redirect_to report_path(@report.patient_id)
  	end
  end

  def destroy
  	if @report.destroy
  		flash[:notice] = "Report has been deleted"
  		redirect_to report_path(@report.patient_id)
  	end
  end

  private
  def set_patient
  	@patient = Patient.find_by(id: params[:id])
  end
  def set_report
  	@report = Report.find_by(id: params[:id])
  end

  def report_params
  	params.require(:report).permit(:age,:parents_name,:describe_problem,:amount)
  end
end
