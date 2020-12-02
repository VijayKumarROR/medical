class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    @user =  User.from_omniauth(request.env["omniauth.auth"])
    if @user.present?
      sign_in(@user, :bypass => true)      
      redirect_to new_user_session_path      
    else
      flash[:error] = "Please register first."
      redirect_to new_user_session_path
    end
  end
  
end
