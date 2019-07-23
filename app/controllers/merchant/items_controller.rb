class Merchant::ItemsController < ApplicationController
  def index
    @merchant = current_user.merchant
    @items = @merchant.items
  end

  def activate
    @item = Item.find(params[:id])
    @item.update(active: true)
    redirect_to "/merchant/#{current_user.merchant_id}/items"
    flash[:activate] = "#{@item.name} is for sale"
  end

  def deactivate
    @item = Item.find(params[:id])
    @item.update(active: false)
    redirect_to "/merchant/#{current_user.merchant_id}/items"
    flash[:deactivate] = "#{@item.name} is no longer for sale"
  end
end
