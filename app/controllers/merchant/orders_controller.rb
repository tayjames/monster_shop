class Merchant::OrdersController < ApplicationController
  before_action :get_merchant

  def show
    @order = Order.find(params[:order_id])
    @items = @order.my_items(@merchant)
    @user = User.find("#{@order.user_id}")
    # binding.pry
    if @order.order_items.all? { |order_item| order_item.status == "fulfilled" }
      @order.update(status: 0)
    end
  end

  def update
    @order_item = OrderItem.find(params[:order_items_id])
    @item = Item.find(@order_item.item_id)
    @item.update(inventory: @item.inventory - @order_item.quantity)
    @order_item.update(status: 1)
    flash[:notice] = "Order for #{@item.name} has been fulfilled."
    redirect_to merchant_orders_show_path(@order_item.order_id)
  end

  private

  def get_merchant
    merchant_id = current_user.merchant_id
    @merchant = Merchant.find(merchant_id)
  end
end
