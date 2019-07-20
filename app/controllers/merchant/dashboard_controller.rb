class Merchant::DashboardController < ApplicationController
  before_action :require_merchant

  def index
    binding.pry
  end

  def show
    merchant_id = current_user.merchant_id
    @merchant = Merchant.find(merchant_id)
  end

private
  def require_merchant
    render file: "/public/404" unless current_merchant_user?
  end
end
