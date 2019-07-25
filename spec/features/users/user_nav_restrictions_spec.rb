require 'rails_helper'

describe "User Navigation Restrictions" do
  context "as a user" do
    it "I do not have access to the following two paths" do
      user = User.create!(email: "123@gmail.com", password: "password", name: "Tom", role: 1, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)

      visit login_path
      fill_in "email", with: "123@gmail.com"
      fill_in "password", with: "password"

      click_button("Login")

      expect(user.role).to eq("registered_user")

      visit '/merchant/dashboard'
      expect(page).to have_content("404: The page you were looking for doesn't exist")

      visit '/admin/dashboard'
      expect(page).to have_content("404: The page you were looking for doesn't exist")
    end
  end
end
