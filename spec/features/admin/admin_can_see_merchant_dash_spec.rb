require 'rails_helper'

describe "Admin Merchants show" do
  context "When I click on a merchants name as an admin" do
    it "I am sent to the admin merchants showpage for that merchant" do
      user = User.create!(email: "123@gmail.com", password: "password", name: "Tom", role: 3, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit "/admin/merchants/#{@brian.id}"

      expect(current_path).to eq("/admin/merchants/#{@brian.id}")

      visit "/merchants"

      click_on "Brians Bagels"

      expect(current_path).to eq("/admin/merchants/#{@brian.id}")

      expect(page).to have_content(@brian.address)
      expect(page).to have_content(@brian.city)
      expect(page).to have_content(@brian.state)
      expect(page).to have_content(@brian.zip)
    end
  end
end



# As an admin user
# When I visit the merchant index page ("/merchants")
# And I click on a merchant's name,
# Then my URI route should be ("/admin/merchants/6")
# Then I see everything that merchant would see
