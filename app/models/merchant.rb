class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :order_items, through: :items
  has_many :users

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    order_items.joins('JOIN orders ON order_items.order_id = orders.id')
               .order('city_state')
               .distinct
               .pluck("CONCAT_WS(', ', orders.city, orders.state) AS city_state")
  end

  def total_items(order)
    items.joins(:order_items).select(:item).where("order_items.order_id = #{order.id}, status").sum(:quantity)
  end

  def all_orders
    items.joins(:order_items).distinct.pluck(:order_id)
  end
end
