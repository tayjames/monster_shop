require 'rails_helper'

RSpec.describe "Merchant Item Edit Page" do
  describe 'as a merchant' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @emily = @megan.users.create!(name: "Emily", role: 2, email: "mm@email.com", password: "password", address: "Street", city: "City", state: "ST", zip: 87654)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@emily)
    end

    it "has a edit item button and I can edit my own items" do
      visit merchant_items_index_path

      within "#item-#{@ogre.id}" do
        click_button "Edit Item"
        expect(current_path).to eq(merchant_items_edit_path(@ogre))
      end

      visit merchant_items_index_path

      within "#item-#{@giant.id}" do
        click_button "Edit Item"
      end

      fill_in "Description", with: "totes tubular and terrific"
      click_button "Update"

      expect(current_path).to eq(merchant_items_index_path)
      expect(page).to have_content("#{@giant.name} has been updated!")
      expect(@giant.reload.description).to eq("totes tubular and terrific")

      visit merchant_items_index_path

      within "#item-#{@giant.id}" do
        click_button "Edit Item"
      end

      fill_in "Name", with: ""
      fill_in "Description", with: ""
      fill_in "Price", with: "-6"
      fill_in "Inventory", with: "-1"

      click_button "Update"

      expect(page).to have_content("Name can't be blank and Description can't be blank")
      expect(page).to_not have_content("#{@giant.name} has been updated!")
    end
  end
end
