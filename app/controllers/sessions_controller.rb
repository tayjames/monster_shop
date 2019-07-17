class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password]) #if user exists and the pw is authenticated, then store user in session
      session[:user_id] = user.id
      # binding.pry
      redirect_to user_profile_path(user)
      flash[:message] = "You are now Logged in #{user.name}"
    else
      render :new
      flash[:notice] = user.errors.full_messages.to_sentence
    end
  end

  def destroy
    session[:user_id] = nil
    redirect root_path
    flash[:notice] = "You are now Logged out."
    #session[:cart] = Hash.new(0)
  end
end
