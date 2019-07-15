class User < ApplicationRecord
  has_many :orders

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :password_digest
  validates_presence_of :name
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :role

  has_secure_password
end
