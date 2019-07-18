class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password]) #if user exists and the pw is authenticated, then store user in session
      session[:user_id] = user.id
      if current_merchant? && current_registered_user?
        redirect_to merchant_dashboard_path
      elsif current_registered_user?
        redirect_to user_profile_path(user)
      elsif current_admin?
        redirect_to admin_dashboard_path
      end
      flash[:message] = "You are now Logged in #{user.name}"
    else
      flash[:notice] = "Email/Password incorrect."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
    flash[:notice] = "You are now Logged out."
    session[:cart] = Hash.new(0)
  end
end
