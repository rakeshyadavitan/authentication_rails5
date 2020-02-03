class ApplicationController < ActionController::Base

  helper_method :current_user

  private

  def current_user
    @_current_user ||= (
      if cookies.encrypted[:remember_token]
        User.find_by(remember_token: cookies.encrypted[:remember_token])
    else
      nil
    end
    )
  end  

  def authenticate_user!
    redirect_to new_session_path, alert: "Not authorized!" if current_user.nil?
  end

end
