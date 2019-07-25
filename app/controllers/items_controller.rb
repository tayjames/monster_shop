class ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items.enabled_items
    else
      @items = Item.enabled_items
    end
    @top_five = Item.top_five
    @bottom_five = Item.bottom_five
  end

  def show
    @item = Item.find(params[:id])
  end
end
