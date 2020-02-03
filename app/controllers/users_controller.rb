class UsersController < ApplicationController

  prepend_before_action :require_no_authentication, only: %i(new create confirm_email)

  def new
    @user = User.new
  end


  def confirm_email
    @user = User.find_by(confirmation_token: params[:confirmation_token])
    if @user
      @user.unconfirmed_email, @user.email = nil, @user.unconfirmed_email
      @user.confirmed_at = Time.now.utc
      @user.save
    end
    redirect_to root_url, notice: "Try logging in now."
  end

end
