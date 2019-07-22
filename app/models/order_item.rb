class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  enum status: ["unfulfilled", "fulfilled"]

  def subtotal
    quantity * price
  end
end
