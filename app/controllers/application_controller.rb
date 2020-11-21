class ApplicationController < ActionController::Base
	before_action :authenticate_user!
	before_action :set_current_user

	def after_sign_in_path_for(resource)
		patients_path
	end

	def set_current_user
		@user = current_user
	end
end
