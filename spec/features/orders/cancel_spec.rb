require 'rails_helper'

RSpec.describe 'As a registered user' do
  describe 'When I visit my Profile Orders page' do
    describe "And I click on a link for order's show page" do
      before(:each) do
        @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
        @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
        @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
        @user_1 = User.create!(email: "123@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 1)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
        @order_1 = @user_1.orders.create!
        @order_2 = @user_1.orders.create!
        @order_item_1 = @order_1.order_items.create!(item: @ogre, quantity: 2, price: @ogre.price)
        @order_item_2 = @order_1.order_items.create!(item: @hippo, quantity: 4, price: @hippo.price)
        @order_2.order_items.create!(item: @ogre, quantity: 5, price: @ogre.price)
        @order_2.order_items.create!(item: @hippo, quantity: 2, price: @hippo.price)
      end

      describe "I see a button or link to cancel the order only if the order is still pending" do
        it "When I click the cancel button for an order, the following happens:\n
        - Each row in the order_items table is given a status of unfulfilled\n
        - The order itself is given a status of cancelled\n
        - Any item quantities in the order that were previously fulfilled have their quantities returned to their respective merchant's inventory for that item.\n
        - I am returned to my profile page\n
        - I see a flash message telling me the order is now cancelled\n
        - And I see that this order now has an updated status of cancelled" do

          visit profile_order_path(@order_1)
          expect(page).to have_button('Cancel Order')

          @order_1.update(status: 0)
          visit profile_order_path(@order_1)
          expect(page).to_not have_button('Cancel Order')

          @order_1.update(status: 2)
          visit profile_order_path(@order_1)
          expect(page).to_not have_button('Cancel Order')

          @order_1.update(status: 3)
          visit profile_order_path(@order_1)
          expect(page).to_not have_button('Cancel Order')

          visit item_path(@ogre)
          click_button 'Add to Cart'
          visit item_path(@ogre)
          click_button 'Add to Cart'
          visit item_path(@hippo)
          click_button 'Add to Cart'
          visit item_path(@hippo)
          click_button 'Add to Cart'
          visit item_path(@hippo)
          click_button 'Add to Cart'
          visit item_path(@hippo)
          click_button 'Add to Cart'

          visit cart_path

          click_button 'Check Out'

          @ogre.update(inventory: 8)
          @hippo.update(inventory: 6)


          @order_1.update(status: 1)
          visit profile_order_path(@order_1)

          @order_item_1.update(status: 0)
          @order_item_2.update(status: 0)

          click_on 'Cancel Order'

          expect(OrderItem.find(@order_item_1.id).status).to eq("unfulfilled")
          expect(OrderItem.find(@order_item_2.id).status).to eq("unfulfilled")

          expect(current_path).to eq(profile_path)

          expect(page).to have_content("Order ID: #{@order_1.id} has been cancelled.")

          visit profile_order_path(@order_1)

          expect(page).to have_content("Status: cancelled")

          visit item_path(@ogre)
          expect(page).to have_content("Inventory: 10")
          visit item_path(@hippo)
          expect(page).to have_content("Inventory: 10")
        end
      end
    end
  end
end
