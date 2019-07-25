class Admin::MerchantsController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:id])
  end

  def index
    @merchants = Merchant.all
  end

  def enable
    @merchant = Merchant.find(params[:id])
    @merchant.update(enabled: true)
    redirect_to admin_merchants_path
    flash[:notice] = "#{@merchant.name} has been enabled"
    @merchant.items.each do |item|
      item.update(active: true)
    end
  end

  def disable
    @merchant = Merchant.find(params[:id])
    @merchant.update(enabled: false)
    redirect_to admin_merchants_path
    flash[:alert] = "#{@merchant.name} has now been disabled"
    @merchant.items.map do |item|
      item.update(active: false)
    end
  end
end
