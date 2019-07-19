class SessionsController < ApplicationController
  def new
    # binding.pry
    if current_user
      if current_merchant_admin?
        redirect_to (merchant_dashboard_path)
        flash[:success] = "You are already logged in"
      elsif current_merchant_user?
        redirect_to (merchant_dashboard_path)
        flash[:success] = "You are already logged in"
      elsif current_registered_user?
        redirect_to (profile_path)
        flash[:success] = "You are already logged in"
      else current_admin?
        redirect_to (admin_dashboard_path)
        flash[:success] = "You are already logged in"
      end
    end
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id

      if current_merchant_user?
        redirect_to merchant_dashboard_path
      elsif current_registered_user?
        redirect_to profile_path
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
