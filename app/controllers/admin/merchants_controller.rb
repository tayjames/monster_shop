class Admin::MerchantsController < Admin::BaseController

  def enable
    @merchant = Merchant.find(params[:id])
    @merchant.update(enabled: true)
    redirect_to merchants_path
  end

  def disable
    @merchant = Merchant.find(params[:id])
    @merchant.update(enabled: false)
    redirect_to merchants_path
  end
end
