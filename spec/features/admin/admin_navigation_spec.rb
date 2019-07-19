require 'rails_helper'

describe "User visits categories index page" do
  context "as admin" do
    it "allows user to see the right stuff in nav" do
      user_1 = User.create!(email: "123@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 3)

      visit '/'

      click_link 'Login'
      fill_in 'Email', with: user_1.email
      fill_in 'Password', with: user_1.password

      click_button 'Login'
      # save_and_open_page

      expect(page).to have_content("Profile")
      expect(page).to have_content("Logout")
      expect(page).to have_content("Admin Dashboard")
      expect(page).to have_content("All Users")

      expect(page).to_not have_content("Login")
      expect(page).to_not have_content("Register")
      expect(page).to_not have_content("Cart:")
    end
  end
end

# As an admin user
# I see the same links as a visitor
# Plus the following links
# - a link to my admin dashboard ("/admin")
# - a link to log out ("/logout")
# - a link to see all users ("/admin/users")
#
# Minus the following links/info:
# - I do not see a link to log in or register
# - a link to my shopping cart ("/cart") or count of cart items
