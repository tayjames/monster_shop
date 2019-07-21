require "rails_helper"

RSpec.describe "Admin User Profile Page" do
  describe "As an admin user" do
    describe "When I visit a user's profile page" do
      before :each do
        @user_1 = User.create!(email: "1234@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 3)
        @user_2 = User.create!(email: "12345@gmail.com", password: "password", name: "Parsley Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 2)
      end

      it "I see the same info the user would see except a link to edit profile" do
        visit login_path

        fill_in 'Email', with: @user_1.email
        fill_in 'Password', with: @user_1.password
        click_button 'Login'

        click_link "All Users"
        click_link "Parsley Jones"

        expect(page).to have_content("Parsley Jones")
        expect(page).to have_content("Address: 456 Main St.")
        expect(page).to have_content("City: Denver")
        expect(page).to have_content("State: CO")
        expect(page).to have_content("ZIP: 80220")
        expect(page).to have_content("E-Mail: 12345@gmail.com")
        expect(page).to_not have_button("Edit Profile")
      end
    end
  end
end
