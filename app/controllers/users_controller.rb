class UsersController < ApplicationController
  before_action :get_user, only: [:show, :edit, :update]
  def register

  end

  def create
    @user = User.new(user_params)
    # binding.pry
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Thanks for Registering"
      flash[:message] = "You are now Logged in #{@user.name}"
      redirect_to user_profile_path(@user)
    else
      flash[:notice] = @user.errors.full_messages.to_sentence
      render :register
    end
  end

  def show
  end

  def edit
  end

  def update
    @user.update(user_params)
    flash[:notice] = "Your Profile has been updated."
    redirect_to user_profile_path(@user)
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :role, :email, :password)
  end


  def get_user
    @user = User.find(params[:id])
  end
end

