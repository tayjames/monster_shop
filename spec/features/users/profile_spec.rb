require 'rails_helper'

RSpec.describe 'User Profile Show' do
  describe 'As a registered user' do
    describe 'when I visit my profile page' do
      before(:each) do
        @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
        @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
        @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
        @user_1 = User.create!(email: "123@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 1)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
        visit profile_path
      end

      it "I see all of my profile data on the page except my password" do
        expect(page).to have_content("PapRica Jones")
        expect(page).to have_content("Address: 456 Main St.")
        expect(page).to have_content("City: Denver")
        expect(page).to have_content("State: CO")
        expect(page).to have_content("ZIP: 80220")
        expect(page).to have_content("E-Mail: 123@gmail.com")
        expect(page).to have_button("Edit Profile")
      end

      describe 'When I have orders placed' do
        it "I see a link on my profile page called 'My Orders'" do
          expect(page).to_not have_link('My Orders')

          @user_1.orders.create

          visit profile_path

          expect(page).to have_link('My Orders')
        end
      end
    end
  end
end
