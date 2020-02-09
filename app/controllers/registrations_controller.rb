class RegistrationsController < ApplicationController

  prepend_before_action :require_no_authentication, only: %i(create)

  def new
    @user = User.new
  end

  def create
    @user = User.find_or_initialize_by(unconfirmed_email: user_params[:email])
    @user.attributes = user_params
    if @user.save
      @user.generate_token_and_send_instructions!(token_type: :confirmation)
      redirect_to root_url, notice: "Check your email with subject 'Confirmation instructions'"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :terms_of_service)
  end

end
