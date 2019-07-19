class User < ApplicationRecord
  belongs_to :merchant, optional: true
  has_many :orders

  validates :email,
            :name,
            :address,
            :city,
            :state,
            :role, presence: true
  validates :password, confirmation: true
  validates_uniqueness_of :email
  validates :zip, numericality: true

  has_secure_password

  enum role: ["visitor", "registered_user", "merchant", "admin"]
end
