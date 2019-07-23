require 'rails_helper'

RSpec.describe "Merchant Dashboard/Profile Show Page" do
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
      @order_1 = @user.orders.create!(name: 'Megan M', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @order_2 = @user.orders.create!(name: 'Megan M', address: '123 Main St', city: 'Denver', state: 'IA', zip: 80218)
      @order_3 = @user.orders.create!(name: 'Megan M', address: '123 Main St', city: 'Denver', state: 'IA', zip: 80218)
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_1.order_items.create!(item: @giant, price: @giant.price, quantity: 4)
      @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3)
      @order_2.order_items.create!(item: @giant, price: @giant.price, quantity: 2)
      @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_2.order_items.create!(item: @hippo_2, price: @hippo_2.price, quantity: 11)
      @order_3.order_items.create!(item: @ogre_2, price: @ogre_2.price, quantity: 5)
      @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 8)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@emily)
    end

    it "I see my profile details, but cannot edit them" do
      visit merchant_dashboard_show_path

      expect(page).to have_content("Name: #{@megan.name}")
      expect(page).to have_content("Street Address: #{@megan.address}")
      expect(page).to have_content("City: #{@megan.city}")
      expect(page).to have_content("State: #{@megan.state}")
      expect(page).to have_content("Zip: #{@megan.zip}")

      expect(page).to_not have_link("Edit Profile")
      expect(page).to_not have_button("Edit Profile")
    end

    it "I see a list of pending orders with items I sell" do
      visit merchant_dashboard_path

      within "#id-#{@order_1.id}" do
        expect(page).to have_content("Order Number: #{@order_1.id}")
        expect(page).to have_content("Order Date: #{@order_1.created_at}")
        expect(page).to have_content("Total Quantity of My Items: #{@megan.item_quantity(@order_1)}")
        expect(page).to have_content("Order Total of My Items: #{number_to_currency(@megan.item_total(@order_1))}")
      end
      
      within "#id-#{@order_1.id}" do
        click_link "#{@order_1.id}"
        expect(current_path).to eq(merchant_orders_show_path(@order_1))
      end
    end

    it "I see a link to only my items" do
      visit merchant_dashboard_path

      click_link "My Items"
      expect(current_path).to eq(merchant_items_index_path)
    end
  end
end
