require 'rails_helper'

RSpec.describe 'admin ships an order' do
  describe 'as an admin user' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @user = User.create!(email: "email@email.com", password: "password", name: "Mellie", address: "Streeterville", city: "Riot", state: "WA", zip: 98765)
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @emily = User.create!(name: "Emily", role: 3, email: "mm@email.com", password: "password", address: "Street", city: "City", state: "ST", zip: 87654)
      @order_0 = @user.orders.create!
      @order_1 = @user.orders.create!(status: 0)
      @order_2 = @user.orders.create!(status: 2)
      @order_3 = @user.orders.create!(status: 3)
      @order_4 = @user.orders.create!
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 4)
      @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3)
      @order_2.order_items.create!(item: @giant, price: @giant.price, quantity: 2)
      @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@emily)
    end

    it "I can ship an order" do
      visit admin_dashboard_path

      within "#order-#{@order_2.id}" do
        expect(page).to_not have_button('Ship Order')
      end

      within "#order-#{@order_1.id}" do
        @order_1.update(status: "packaged")
        expect(page).to have_button('Ship Order')

        click_button 'Ship Order'

        expect(@order_1.reload.status).to eq('shipped')
      end

      expect(current_path).to eq(admin_dashboard_path)
    end
  end
end
