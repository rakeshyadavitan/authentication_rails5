class RegistrationsController < ApplicationController

  prepend_before_action :require_no_authentication, only: %i(create)

  def new
    @user = User.new
  end

  def create
    @user = User.find_or_initialize_by(email: user_params[:email])
    @user.attributes = user_params
    if @user.save
      redirect_to root_url, notice: "User Created"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :terms_of_service)
  end

end
