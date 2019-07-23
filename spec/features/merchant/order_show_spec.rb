require 'rails_helper'

RSpec.describe 'merchant order show page' do
  describe 'as a merchant' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 6 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 6 )
      @ogre_2 = @megan.items.create!(name: 'Ogre the Voyager', description: "I'm a Stinky Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 12 )
      @hippo_2 = @brian.items.create!(name: 'Pippo the Hippo', description: "I'm a Peppy Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 14 )
      @giant_2 = @megan.items.create!(name: 'Bryan the Giant', description: "I'm a named Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 30 )
      @emily = @megan.users.create!(name: "Emily", role: 2, email: "mm@email.com", password: "password", address: "Street", city: "City", state: "ST", zip: 87654)
      @user = User.create!(email: "email@email.com", password: "password", name: "Mellie", address: "Streeterville", city: "Riot", state: "WA", zip: 98765)
      @order_1 = @user.orders.create!(name: "Mellie", address: "Streeterville", city: "Riot", state: "WA", zip: 98765)
      @order_2 = @user.orders.create!(name: "Mellie", address: "Streeterville", city: "Riot", state: "WA", zip: 98765)
      @order_3 = @user.orders.create!(name: "Mellie", address: "Streeterville", city: "Riot", state: "WA", zip: 98765)
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 4)
      @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3)
      @order_2.order_items.create!(item: @giant, price: @giant.price, quantity: 2)
      @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_2.order_items.create!(item: @hippo_2, price: @hippo_2.price, quantity: 11)
      @order_3.order_items.create!(item: @ogre_2, price: @ogre_2.price, quantity: 5)
      @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 8)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@emily)
    end

    it "shows all of the order and user information" do
      visit merchant_orders_show_path(@order_1)

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
      save_and_open_page
      expect(page).to have_content("Item Name: #{@ogre.name}")
      expect(page).to_not have_content(@hippo.name)
      expect(page).to_not have_content(@giant.name)
      expect(page).to have_css("img[src*='#{@ogre.image}']")
      expect(page).to have_content("Item Price: #{number_to_currency(@ogre.price)}")
      expect(page).to have_content(@order_1.quantity_of_item(@ogre))

      click_link "#{@ogre.name}"
      expect(current_path).to eq(item_path(@ogre))
    end
  end
end
