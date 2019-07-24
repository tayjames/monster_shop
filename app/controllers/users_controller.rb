class UsersController < ApplicationController
  before_action :get_user, only: [:show, :edit, :update, :edit_password, :update_password]
  def register

  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Thanks for Registering"
      flash[:message] = "You are now Logged in #{@user.name}"
      redirect_to profile_path
    else
      flash[:notice] = @user.errors.full_messages.to_sentence
      render :register
    end
  end

  def show
    
  end

  def edit
  end

  def edit_password
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your Profile has been updated."
      redirect_to profile_path
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  def update_password
    if @user.update(user_params)
      flash[:notice] = "Your password has been updated."
      redirect_to profile_path
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :edit_password
    end
  end

  private

  def user_params
    params.permit(
      :name,
      :address,
      :city,
      :state,
      :zip,
      :role,
      :email,
      :password,
      :password_confirmation
    )
  end

  def get_user
    if current_registered_user?
      @user = current_user
      # @user = User.find(session[:user_id])
    else
      render file: "/public/404"
    end
  end
end
