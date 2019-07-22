class OrdersController < ApplicationController

  def index
    @orders = current_user.orders
  end

  def show
    @order = Order.find(params[:id])
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
      end
      session.delete(:cart)
      redirect_to profile_orders_path
      flash[:notice] = "Your order has been created!"
    end
  end

  def index
    @orders = current_user.orders
  end
end
