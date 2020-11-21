class PatientsController < ApplicationController
	require 'csv'
	require 'json'
	require 'nokogiri'


  def index
  end

  def new
  	@patient = Patient.new
  end

  def create
  	extension = file_extension(params[:file])
  	binding.pry
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

  def import_csv
  	csv = CSV.read(params[:file], :headers=>true)
  	@errors = []
		csv.each do |row|
  		patient = Patient.new(row.to_h)
  		if patient.save
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
			else
				@errors << column.css("first_name").inner_text
			end
		end
		redirection
  end

  private

  def redirection
  	unless @errors.present?
			flash[:notice] = "Patients imported successfully"
			redirect_to new_patient_path
		end
  end

  def file_extension(file)
		File.extname(file.original_filename)
	end

end
