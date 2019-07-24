require 'rails_helper'

RSpec.describe 'Merchant fulfills' do
  describe 'As a Merchant' do
    describe 'when I visit an order showpage' do
      before :each do
        @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
        @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
        @hippo = @megan.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
        @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 90, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 13 )
        @user_1 = @megan.users.create!(email: "13@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 2)
        @user_2 = @megan.users.create!(email: "123@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 2)
        @order_1 = @user_1.orders.create!
        @order_item_1 = @order_1.order_items.create!(item: @hippo, quantity: 4, price: @hippo.price)
        @order_item_2 = @order_1.order_items.create!(item: @ogre, quantity: 11, price: @ogre.price)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
      end

      it "it can fulfill a part of an order" do
        visit merchant_orders_show_path(@order_1)

        within "#item-#{@hippo.id}" do
          expect(page).to have_button("Fulfill")
          expect(page).to have_content("Status: #{@order_item_1.status}")
          expect(page).to_not have_content("Not enough inventory for this order!")

          click_button "Fulfill"
        end

        expect(current_path).to eq(merchant_orders_show_path(@order_1))

        expect(page).to have_content("Order for #{@hippo.name} has been fulfilled.")


        expect(@hippo.reload.inventory).to eq(6)

        within "#item-#{@hippo.id}" do
          expect(page).to have_content("fulfilled")
        end

      end

      it "it can't fulfill a part of an order if quanity is larger than inventory" do
        visit merchant_orders_show_path(@order_1)

        within "#item-#{@ogre.id}" do
          expect(page).to_not have_button("Fulfill")
          expect(page).to have_content("Status: #{@order_item_2.status}")
        end

      end

    end

  end

end
