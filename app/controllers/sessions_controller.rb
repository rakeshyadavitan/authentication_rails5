class SessionsController < ApplicationController

  before_action :set_user, only: :create

  def new
  end

  def create
    authorized_user = User.authenticate(params[:email],params[:password])
    if authorized_user
      login!
      redirect_to root_url, notice: "Logged in!"
    else
      flash.now.alert = "Email or password is invalid"
      render :new
    end
  end

  def destroy
    cookies.delete(:remember_token)
    redirect_to root_url, notice: "Logged out!"
  end

  private

  def login!
    unless @user.remember_token
      @user.generate_token(:remember_token)
      @user.save
    end
    if params[:remember_me]
      cookies.encrypted.permanent[:remember_token] = { value: @user.remember_token, expires: 2.weeks.from_now }
    else
      cookies.encrypted[:remember_token] = @user.remember_token
    end
  end

  def set_user
    @user = User.find_by(email: params[:email])
  end

end
