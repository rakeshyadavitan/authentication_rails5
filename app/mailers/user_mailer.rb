class UserMailer < ApplicationMailer

  def email_confirmation
    @user = params[:user]
    @email = @user.unconfirmed_email
    @token = @user.confirmation_token

    mail to: @email, subject: "Confirmation instructions"
  end

end
