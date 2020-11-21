class ApplicationController < ActionController::Base
	before_action :authenticate_user!
	before_action :set_current_user
	before_action :set_patients

	def after_sign_in_path_for(resource)
		patients_path
	end

	def set_current_user
		@user = current_user
	end

	def set_patients
		@patients = @user.company.patients if current_user
	end
end
