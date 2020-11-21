class PatientsController < ApplicationController
	require 'csv'
	require 'json'
	require 'nokogiri'
	before_action :find_patient, only: [:edit, :destroy, :update, :report ,:report_generator]


  def index
  end

  def new
  	@patient = Patient.new
  end

  def create
  	extension = file_extension(params[:file])
  	if extension.include?('csv')
  		import_csv
  	elsif extension.include?('json')
  		import_json
  	elsif extension.include?('xml')
  		import_xml
  	elsif ['csv','json','xml'].exclude?(extension)
  		flash[:error] = "Only accept CSV/JSON/XML format"
  		redirect_to new_patient_path
  	end
  	if @errors.present?
  		flash[:error] = "Not saved, please see the error below"
			render :new
  	end
  end

  def edit
  end

  def update
  	if @patient.update_attributes(patient_params)
  		flash[:notice] = "Patient has been updated"
  		redirect_to patients_path
  	end
  end

  def destroy
  	if @patient.destroy
  		flash[:notice] = "Patient has been deleted"
  		redirect_to patients_path
  	end
  end

  def report
  end

  def report_generator
  	if @patient.present? && params.present?
  		params["reports"].keys.each do |param|
  			report = Report.new(age: params[:reports][param]["age"],parents_name:params[:reports][param]["parents_name"],describe_problem: params[:reports][param]["describe_problem"],amount: params[:reports][param]["amount"],user_id: @user.id, patient_id: @patient.id)
  			report.update(user_id: @user.id, patient_id: @patient.id)
  			report.attachments.create(name: params[:attachments][param])
  		end
  	end
  	flash[:notice] = "Reports generated successfully"
  	redirect_to patients_path
  end

  def import_csv
  	csv = CSV.read(params[:file], :headers=>true)
  	@errors = []
		csv.each do |row|
  		patient = Patient.new(row.to_h)
  		if patient.save
  			patient.update(company_id: @user.company.try(:id))
  		else 
  			@errors << row["first_name"]
  		end
		end
		redirection
  end

  def import_json
  	@errors = []
  	patient_list = JSON.parse(File.read(params[:file]))
  	patient_list["patients"].each do |patient_hash|
  		patient = Patient.new(patient_hash)
  		if patient.save
  			patient.update(company_id: @user.company.try(:id))
  		else
  			@errors << patient_hash[:first_name]
  		end
		end
		redirection
  end

  def import_xml
  	@errors = []
		doc = Nokogiri::XML(params[:file])
		doc.css(:patient).each do |patient|
			column = patient.children
			patient = Patient.new(first_name: column.css("first_name").inner_text,last_name: column.css("last_name").inner_text,email: column.css("email").inner_text)
			if patient.save
				patient.update(company_id: @user.company.try(:id))
			else
				@errors << column.css("first_name").inner_text
			end
		end
		redirection
  end

  def export_options
  	if params[:type].eql?('csv')
  		export_csv
  	elsif params[:type].eql?('json')
  		export_json
  	end
  end

  def export_csv
  	file = "#{Rails.root}/public/patient_data.csv"
		headers = ["Patient ID", "Name", "Price", "Description"]
		respond_to do |format|
      format.csv { send_data @user.patients, filename: "patients-#{Date.today}.csv" }
    end
  end

  def export_json
  	data = @patients.to_json
    send_data data, :type => 'application/json; header=present', :disposition => "attachment; filename=patients.json"
  end

  private

  def find_patient
  	@patient = Patient.find_by(id: params[:id])
  end

  def redirection
  	unless @errors.present?
			flash[:notice] = "Patients imported successfully"
			redirect_to new_patient_path
		end
  end

  def file_extension(file)
		File.extname(file.original_filename)
	end

	def patient_params
		params.require(:patient).permit(:first_name, :last_name)
	end

end
