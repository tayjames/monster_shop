class UsersController < ApplicationController
  def register

  end

  def create
    user = User.new(user_params)
    # binding.pry
    if user.save
      flash[:notice] = "Thanks for Registering"
      flash[:message] = "You are now Logged in #{user.name}"
      redirect_to profile_path(user)
    else
      flash[:notice] = user.errors.full_messages.to_sentence
      render :register
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :role, :email, :password)
  end

end
