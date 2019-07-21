class Merchant::DashboardController < ApplicationController
  before_action :require_merchant, :find_merchant

  def index
    order_ids = @merchant.order_items.map do |oi|
      oi.order_id
    end
    all_orders = order_ids.map do |id|
      id = Order.find(id)
    end
    @orders = all_orders.uniq
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
