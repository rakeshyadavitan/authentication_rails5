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

  def require_no_authentication
    if cookies[:remember_token]
      redirect_to root_url, alert: "Already authenticated!"
    end
  end

end
