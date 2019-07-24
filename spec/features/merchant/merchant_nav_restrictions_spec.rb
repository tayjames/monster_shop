require 'rails_helper'

describe "Merchant Navigation Restrictions" do
  context "as a merchant" do
    it "I do not have access to the following three paths" do
      megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      user = megan.users.create!(email: "123@gmail.com", password: "password", name: "Tom", role: 2, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)

      visit login_path
      fill_in "email", with: "123@gmail.com"
      fill_in "password", with: "password"

      click_button("Login")

      expect(user.role).to eq("merchant_admin")

      visit '/merchant/dashboard'
      expect(page).to_not have_content("404: The page you were looking for doesn't exist")

      visit '/admin/dashboard'
      expect(page).to have_content("404: The page you were looking for doesn't exist")

      visit '/profile'
      expect(page).to have_content("404: The page you were looking for doesn't exist")



    end
  end
end





# As a Merchant
# When I try to access any path that begins with the following, then I see a 404 error:
# - '/profile'
# - '/admin'
# - '/cart'
