require "rails_helper"

describe "User visits categories index page" do
  context "as admin" do
    it "allows user to see the right stuff in nav" do
      user_1 = User.create!(email: "123@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 1)

      visit '/'

      click_link 'Login'
      fill_in 'Email', with: user_1.email
      fill_in 'Password', with: user_1.password

      click_button 'Login'
      # save_and_open_page

      expect(page).to have_content("Profile")
      expect(page).to have_content("Logout")
      expect(page).to_not have_content("Login")
      expect(page).to_not have_content("Register")
    end
  end
end
