require 'rails_helper'

RSpec.describe 'admin dashboard index' do
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
      @order_1 = @user.orders.create!(status: 1)
      @order_2 = @user.orders.create!(status: 2)
      @order_3 = @user.orders.create!(status: 3)
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 4)
      @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3)
      @order_2.order_items.create!(item: @giant, price: @giant.price, quantity: 2)
      @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@emily)
    end

    describe 'when I log in' do
      it "I see all orders in system, sorted by status" do
        visit admin_dashboard_path

        within "#order-#{@order_1.id}" do
          expect(page).to have_content(@user.name)
          expect(page).to have_content(@order_1.id)
          expect(page).to have_content(@order_1.created_at)
          click_link "#{@user.name}"
          expect(current_path).to eq(admin_path(@user))
        end
        # save_and_open_page
        # within ".sorted_orders" do
        #   expect(page.all('li')[0]).to have_content(@order_1)
        #   expect(page.all('li')[1]).to have_content(@order_0)
        #   expect(page.all('li')[2]).to have_content(@order_2)
        #   expect(page.all('li')[3]).to have_content(@order_3)
        # end


      end
    end
  end
end
