require 'rails_helper'

RSpec.describe Order do
  describe 'relationships' do
    it {should have_many :order_items}
    it {should have_many(:items).through(:order_items)}
    it { should belong_to :user}
  end

  describe 'validations' do
    it {should validate_presence_of :status}
  end

  describe 'instance methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @user_1 = User.create!(email: "123@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 1)
      @order_1 = @user_1.orders.create!
      @order_2 = @user_1.orders.create!
      @order_item = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3)
      @order_2.order_items.create!(item: @giant, price: @giant.price, quantity: 2)
      @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
    end

    it ".grand_total" do
      expect(@order_1.grand_total).to eq(190.5)
      expect(@order_2.grand_total).to eq(140.5)
    end

    it ".total_quantity" do
      expect(@order_1.total_quantity).to eq(5)
      expect(@order_2.total_quantity).to eq(4)
    end

    it ".quantity_of_item" do
      expect(@order_1.quantity_of_item(@ogre)).to eq(2)
      expect(@order_1.quantity_of_item(@hippo)).to eq(3)
      expect(@order_2.quantity_of_item(@giant)).to eq(2)
      expect(@order_2.quantity_of_item(@ogre)).to eq(2)
    end

    it ".pending?" do
      expect(@order_1.pending?).to eq(true)
      expect(@order_2.pending?).to eq(true)
    end

    it '.my_items(user)' do
      expect(@order_1.my_items(@megan)).to eq([@ogre])
    end

    it '.find_order_item(item, order)' do
      expect(@order_1.find_order_item(@ogre, @order_1)).to eq(@order_item)
    end

  end
end
