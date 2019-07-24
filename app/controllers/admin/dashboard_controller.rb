class Admin::DashboardController < Admin::BaseController
  def index
    @orders = Order.all
    # binding.pry
    # @sorted_orders = @orders.order(:status)
  end
end
