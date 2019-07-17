class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart, :current_user, :current_registered_user?, :current_admin?, :current_merchant?


  def cart
    @cart ||= Cart.new(session[:cart])
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    # binding.pry
  end

  def generate_flash(resource)
    resource.errors.messages.each do |validation, message|
      flash[validation] = "#{validation}: #{message}"
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_registered_user?
    current_user.role == "registered_user"
  end

  def current_merchant?
    current_user.merchant_id
  end

  def current_admin?
    current_user.role == "admin"
  end
end
