class Order < ApplicationRecord
  has_many :order_items
  has_many :items, through: :order_items

  belongs_to :user

  validates_presence_of :status
  enum status: ["packaged", "pending", "shipped", "cancelled"]

  def grand_total
    order_items.sum('price * quantity')
  end

  def total_quantity
    order_items.sum(:quantity)
  end

  def quantity_of_item(item)
    order_items.where(item_id: item.id).sum(:quantity)
  end

  def my_items(merchant)
    items.where("items.merchant_id = #{merchant.id}").distinct
  end

  def find_order_item(item, order)
    order_items.where(order_id: order.id, item_id: item.id).first
  end
end
