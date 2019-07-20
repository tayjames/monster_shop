class Admin::MerchantsController < Admin::BaseController

  def enable
    @merchant = Merchant.find(params[:id])
    @merchant.update(enabled: true)
    redirect_to merchants_path
  end

  def disable
    # binding.pry
    @merchant = Merchant.find(params[:id])
    @merchant.update(enabled: false)
    # binding.pry
    redirect_to merchants_path
  end

end
