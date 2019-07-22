class OrdersController < ApplicationController
  before_action :get_order, only: [:show, :update]

  def index
    @orders = current_user.orders
  end

  def show
    @pending = @order.pending?
  end

  def create
    if current_user == nil
      link = "<a href=\"#{url_for(register_path)}\">Register</a>"
      flash[:error] = "You must #{link} to finish checkout"
      redirect_to cart_path
    end
    order = Order.new(user_id: current_user.id, name: current_user[:name], address: current_user[:address], city: current_user[:city], state: current_user[:state], zip: current_user[:zip])
    if order.save
      cart.items.each do |item|
        order.order_items.create({
          item: item,
          quantity: cart.count_of(item.id),
          price: item.price
          })
        item.update(inventory: item.inventory - cart.count_of(item.id))
      end
      session.delete(:cart)
      redirect_to profile_orders_path
      flash[:notice] = "Your order has been created!"
    end
  end

  def update
    @order.update(status: 3)
    @order.order_items.each do |order_item|
      order_item.update(status: 0)
    end

    @order.items.each do |item|
      item.update(inventory: item.inventory + @order.quantity_of_item(item))
    end
    flash[:notice] = "Order ID: #{@order.id} has been cancelled."
    redirect_to profile_path
  end

  private

  def get_order
    @order = Order.find(params[:id])
  end
  #
  # def order_params
  #   params.require(:user).permit(:name, :address, :city, :state, :zip)
  # end
end
