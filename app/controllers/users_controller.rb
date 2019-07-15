class UsersController < ApplicationController
  def register

  end

  def create
      user = User.create!(user_params)
      flash[:notice] = "Thanks for Registering"
      flash[:message] = "You are now Logged in #{user.name}"
      redirect_to profile_path(user)
  end

  def show

  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :role, :email, :password)
  end

end
