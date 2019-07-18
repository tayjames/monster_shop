require 'rails_helper'

RSpec.describe 'User Profile Show' do
  describe 'As a registered user' do
    describe 'when I visit my profile page' do
      before(:each) do
        @user_1 = User.create!(email: "123@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 1)
      end

      it "I see all of my profile data on the page except my password" do


        visit login_path
        fill_in "email", with: "123@gmail.com"
        fill_in "password", with: "password"

        click_button("Login")

        expect(@user_1.role).to eq("registered_user")
        visit "/profile"

        expect(page).to have_content("PapRica Jones")
        expect(page).to have_content("Address: 456 Main St.")
        expect(page).to have_content("City: Denver")
        expect(page).to have_content("State: CO")
        expect(page).to have_content("ZIP: 80220")
        expect(page).to have_content("E-Mail: 123@gmail.com")
        expect(page).to have_button("Edit Profile")
      end
    end
  end
end
