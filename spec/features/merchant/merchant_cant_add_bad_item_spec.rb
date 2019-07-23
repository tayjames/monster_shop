require 'rails_helper'

describe "Merchant item creation" do
  context "can't create an item with bad info" do
      before :each do
        @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
        @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
        @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
        @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
        @tay = @megan.users.create!(email: "merchant@gmail.com", password: "password", name: "Tay", role: 2, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)
        @ty = User.create!(email: "admin@gmail.com", password: "password", name: "Ty", role: 3, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)
        @tye = User.create!(email: "user@gmail.com", password: "password", name: "Ty", role: 1, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)

    end



    it "can navigate to the merchant items page when a merchant" do

      visit login_path

      fill_in "email", with: "merchant@gmail.com"
      fill_in "password", with: "password"

      expect(page).to_not have_content("Merchant Items")

      click_button "Login"

      click_link "Merchants Items"

      click_link "New Item"

      name = 'Albatross'
      description = "I'm an Albatross!"
      # price = 99
      # inventory = 5000



      fill_in 'Name', with: name
      fill_in 'Description', with: description

      click_button 'Create Item'

      expect(page).to have_content("Price: can't be blank")
      expect(page).to have_content("Inventory: can't be blank")
      expect(page).to have_button('Create Item')

    end


  end
end



# As a merchant
# When I try to add a new item
# If any of my data is incorrect or missing (except image)
# Then I am returned to the form
# I see one or more flash messages indicating each error I caused
# All fields are re-populated with my previous data
