class User < ApplicationRecord
  has_many :orders

  validates :email,
            :password,
            :name,
            :address,
            :city,
            :state, presence: { message: "can't be blank"}
  validates_uniqueness_of :email
  validates_presence_of :role
  validates :zip, numericality: { message: "is not a number"}

  has_secure_password
  enum role: ["visitor", "registered_user", "merchant", "admin"]
end
