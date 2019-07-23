class Merchant::OrdersController < ApplicationController
  before_action :get_merchant

  def show
    @order = Order.find(params[:order_id])
    @items = @order.my_items(@merchant)
    # binding.pry
    @user = User.find("#{@order.user_id}")
  end

  private

  def get_merchant
    merchant_id = current_user.merchant_id
    @merchant = Merchant.find(merchant_id)
  end
end
