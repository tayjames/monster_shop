class Merchant::DashboardController < ApplicationController
  before_action :require_merchant, :find_merchant

  def index
    @pending_orders = @merchant.all_orders.map do |order|
      Order.find(order)
    end.find_all { |order| order.pending? }
  end

  def show
  end

  private
  
  def require_merchant
    render file: "/public/404" unless current_merchant_user?
  end

  def find_merchant
    merchant_id = current_user.merchant_id
    @merchant = Merchant.find(merchant_id)
  end
end
