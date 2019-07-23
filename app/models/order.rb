class Order < ApplicationRecord

  has_many :order_items
  has_many :items, through: :order_items

  belongs_to :user

  validates_presence_of :status
  enum status: ["pending", "packaged", "shipped", "cancelled"]

  def grand_total
    order_items.sum('price * quantity')
  end

  def total_quantity
    order_items.sum(:quantity)
  end

  def quantity_of_item(item)
    order_items.where(item_id: item.id).sum(:quantity)
  end

  def my_items(user)
    # binding.pry
    items.where("items.merchant_id = #{user.id}")
  end

  #
    # def pending?
  #   status == "pending"
  # end

  # def merchant_item_quantity(merchant)
  #   binding.pry
  #   # merchant.items.joins(:order_items).where("items.id = order_items.item_id").where("orders.id = order_items.order_id").sum(:quantity)
  #   items.joins(:order_items).where("items.merchant_id = #{merchant.id}").count
  #   items.joins(:order_items).where("items.merchant_id = #{merchant.id}").sum("order_items.quantity")
  #   items.joins(:order_items).where("order_items.order_id = #{id}").sum("order_items.quantity")
  #   items.joins(:order_items).where("items.merchant_id = #{merchant.id}").where("order_items.order_id = #{id}").sum("order_items.quantity")
  #   # items.where("item.merchant_id = #{merchant.id")
  # end
end
