require "rails_helper"

RSpec.describe User, type: :model do
  describe "Relationships" do
    it { should have_many :orders }
  end

  describe "Validations" do
    it { should validate_presence_of :email}
    it { should validate_uniqueness_of :email}
    it { should validate_presence_of :password}
    it { should validate_presence_of :name}
    it { should validate_presence_of :address}
    it { should validate_presence_of :city}
    it { should validate_presence_of :state}
    it { should validate_numericality_of :zip}
    it { should validate_presence_of :role}
  end

  describe "Instance Methods" do
    it "#orders?" do
      user_1 = User.create!(email: "789@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 1)
      user_1.orders.create!(name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220)

      expect(user_1.orders?).to eq(false)
    end
  end
end
