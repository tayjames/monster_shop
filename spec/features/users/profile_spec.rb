require 'rails_helper'

RSpec.describe 'User Profile Show' do
  describe 'As a registered user' do
    describe 'when I visit my profile page' do
      before(:each) do
        @user_1 = User.create!(email: "123@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 1)
      end

      it "I see all of my profile data on the page except my password" do
        visit user_profile_path(@user_1)

        expect(page).to have_content("PapRica Jones")
        expect(page).to have_content("Address: 456 Main St.")
        expect(page).to have_content("City: Denver")
        expect(page).to have_content("State: CO")
        expect(page).to have_content("ZIP: 80220")
        expect(page).to have_content("E-Mail: 123@gmail.com")
      end
    end
  end
end
