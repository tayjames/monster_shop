require 'rails_helper'

RSpec.describe 'User checkout' do
  describe 'as a registered user' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 6 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 6 )
      @user = User.create!(email: "email@email.com", password: "password", name: "Mellie", address: "Streeterville", city: "Riot", state: "WA", zip: 98765)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    describe 'when I add items to my cart' do
      describe 'and visit my cart I see something to check out' do
        describe 'creates a pending order when I check out' do
          it 'empties my cart and shows me my orders page' do
            visit item_path(@ogre)
            click_on('Add to Cart')

            visit item_path(@ogre)
            click_on('Add to Cart')

            click_on('Cart')
            click_on('Check Out')

            order = Order.last

            expect(order.status).to eq("pending")
            expect(order.user_id).to eq(@user.id)
            expect(current_path).to eq(profile_orders_path)
            expect(page).to have_content("Your order has been created!")

            within ".orders"
              expect(page).to have_content("#{order.id}")
            end
            # expect(cart.count).to eq(0)
          end
        end
      end
    end
  end
