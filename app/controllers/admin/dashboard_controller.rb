class Admin::DashboardController < Admin::BaseController
  def index
    @orders = Order.all.order(:status)
  end
end
