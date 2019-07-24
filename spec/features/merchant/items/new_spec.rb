require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant adds an Item' do
  describe 'As a merchant' do
    describe 'When  visit my items page' do
      before :each do
        @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        @merchant_admin = @megan.users.create!(name: "Rubbertoe", email: "rb@gmail.com", password: "password",  address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, role: 2)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
        visit merchant_items_index_path
      end

      it 'I see a link to add a new item' do

        click_link 'New Item'

        expect(current_path).to eq(merchant_items_new_path)
      end

      it 'I can create an item for a merchant' do
        name = 'Asparagus'
        description = "Musty"
        price = 4.99
        image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw'
        inventory = 70

        visit merchant_items_new_path

        fill_in 'Name', with: name
        fill_in 'Description', with: description
        fill_in 'Price', with: price
        fill_in 'Image', with: image
        fill_in 'Inventory', with: inventory
        click_button 'Create Item'

        expect(current_path).to eq(merchant_items_index_path)
        expect(page).to have_link(name)
        expect(page).to have_content(description)
        expect(page).to have_content("Price: #{number_to_currency(price)}")
        expect(page).to have_content("Active")
      end

      it 'I can not create an item for a merchant with an incomplete form' do
        name = 'Ogre'

        visit merchant_items_new_path

        fill_in 'Name', with: name
        click_button 'Create Item'

        expect(page).to have_content("Description: can't be blank")
        expect(page).to have_content("Price: can't be blank")
        expect(page).to have_content("Inventory: can't be blank")
        expect(page).to have_button('Create Item')
      end

      it "If I left the image field blank, I see a placeholder image for the thumbnail" do
        name = 'ohkeh'
        description = "snah"
        price = 8.99
        inventory = 60

        visit merchant_items_new_path

        fill_in 'Name', with: name
        fill_in 'Description', with: description
        fill_in 'Price', with: price
        fill_in 'Inventory', with: inventory
        click_button 'Create Item'


        expect(current_path).to eq(merchant_items_index_path)
        expect(page).to have_link(name)
        expect(page).to have_content(description)
        expect(page).to have_css("img[src*='#{Item.last.image}']")
        expect(page).to have_content("Price: #{number_to_currency(price)}")
        expect(page).to have_content("Active")
      end
    end
  end
end
