require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant Item Index Page' do
  describe 'As a visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @demon = @brian.items.create!(name: 'Demon', description: "I'm a Demon!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )
      @user_2 = @brian.users.create!(email: "12345@gmail.com", password: "password", name: "Parsley Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 2)
    end
    
    it 'I can see a list of that merchants items' do
      visit "/merchants/#{@megan.id}/items"

      within "#item-#{@ogre.id}" do
        expect(page).to have_link(@ogre.name)
        expect(page).to have_content(@ogre.description)
        expect(page).to have_content("Price: #{number_to_currency(@ogre.price)}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@ogre.inventory}")
        expect(page).to have_content("Sold by: #{@megan.name}")
        expect(page).to have_content(@megan.name)
      end

      within "#item-#{@giant.id}" do
        expect(page).to have_link(@giant.name)
        expect(page).to have_content(@giant.description)
        expect(page).to have_content("Price: #{number_to_currency(@giant.price)}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@giant.inventory}")
        expect(page).to have_content("Sold by: #{@megan.name}")
        expect(page).to have_content(@megan.name)
      end

      expect(page).to_not have_css("#item-#{@hippo.id}")
    end

    it "I see a button to de/activate the item next to each item that is de/active" do
      visit login_path

      fill_in 'Email', with: @user_2.email
      fill_in 'Password', with: @user_2.password
      click_button 'Login'

      visit "/merchant/#{@brian.id}/items"

      expect(@hippo.active).to eq(true)
      expect(@demon.active).to eq(false)

      within "#item-#{@hippo.id}" do
        expect(page).to have_button("Deactivate")
        click_button('Deactivate')
      end

      expect(@hippo.reload.active).to eq(false)
      expect(current_path).to eq("/merchant/#{@brian.id}/items")
      expect(page).to have_content("#{@hippo.name} is no longer for sale")

      within "#item-#{@demon.id}" do
        expect(page).to have_button("Activate")
        click_button('Activate')
      end
      expect(@demon.reload.active).to eq(true)
      expect(current_path).to eq("/merchant/#{@brian.id}/items")
      expect(page).to have_content("#{@demon.name} is for sale")
    end
  end
end
