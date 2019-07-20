require 'rails_helper'

RSpec.describe 'As a registered user' do
  describe 'When I visit my profile orders page' do
    before(:each) do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
      @user_1 = User.create!(email: "123@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 1)
      @order_1 = @user_1.orders.create!(name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220)
      @order_2 = @user_1.orders.create!(name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220)
      @order_1.order_items.create!(item: @ogre, quantity: 2, price: @ogre.price)
      @order_1.order_items.create!(item: @hippo, quantity: 4, price: @hippo.price)
      @order_2.order_items.create!(item: @ogre, quantity: 5, price: @ogre.price)
      @order_2.order_items.create!(item: @hippo, quantity: 6, price: @hippo.price)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end

    it "I see every order I've made, which includes the following information:\n
    - the ID of the order, which is a link to the order show page\n
    - the date the order was made\n
    - the date the order was last updated\n
    - the current status of the order\n
    - the total quantity of items in the order\n
    - the grand total of all items for that order" do

      visit profile_orders_path

      within "#order-#{@order_1.id}" do
        expect(page).to have_content("Order ID:")
        expect(page).to have_link(@order_1.id)
        expect(page).to have_content("Date Created: #{@order_1.created_at.strftime("%m/%d/%Y")}")
        expect(page).to have_content("Date Updated: #{@order_1.updated_at.strftime("%m/%d/%Y")}")
        expect(page).to have_content("Status: #{@order_1.status}")
        expect(page).to have_content("Total Quantity of Items: #{@order_1.total_quantity}")
        expect(page).to have_content("Grand Total: #{@order_1.grand_total}")
      end

      within "#order-#{@order_2.id}" do
        expect(page).to have_content("Order ID:")
        expect(page).to have_link(@order_2.id)
        expect(page).to have_content("Date Created: #{@order_2.created_at.strftime("%m/%d/%Y")}")
        expect(page).to have_content("Date Updated: #{@order_2.updated_at.strftime("%m/%d/%Y")}")
        expect(page).to have_content("Status: #{@order_2.status}")
        expect(page).to have_content("Total Quantity of Items: #{@order_2.total_quantity}")
        expect(page).to have_content("Grand Total: #{@order_2.grand_total}")
      end
    end
  end
end
