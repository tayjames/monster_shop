class Order < ApplicationRecord
  has_many :order_items
  has_many :items, through: :order_items

  belongs_to :user

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip,
                        :status
  enum status: ["pending", "packaged", "shipped", "cancelled"]

  def grand_total
    order_items.sum('price * quantity')
  end

  def total_quantity
    order_items.sum(:quantity)
  end

  def merchant_item_quantity(merchant)
    binding.pry
    Order.joins(:order_items).joins(:items).select(:items).where("#{item.merchant_id} = merchant.id").sum(:quantity)
  end

  def merchant_item_total
  end
end
