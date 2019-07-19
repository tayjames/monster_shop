class Item < ApplicationRecord
  belongs_to :merchant
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews, dependent: :destroy

  validates_presence_of :name,
                        :description,
                        :image,
                        :price,
                        :inventory

  def sorted_reviews(limit = nil, order = :asc)
    reviews.order(rating: order).limit(limit)
  end

  def average_rating
    reviews.average(:rating)
  end

  def self.enabled_items
    Item.where(active: true)
  end

  def self.top_five
    # binding.pry
    items = Item.joins(:order_items).select('items.*, sum(quantity)').group(:id).order(:sum_item)
  end

  def self.bottom_five
  end
end
