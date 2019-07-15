require 'rails_helper'

RSpec.describe "User Registration" do
  describe "As a Visitor" do
    it "I, visitor, can register as a user" do
      visit register_path

      fill_in "Name", with: "McLovin'"
      fill_in "Address", with: "892 Mamoma St"
      fill_in "City", with: "Honolulu"
      fill_in "State", with: "HI"
      fill_in "Zip", with: 96820
      fill_in "Email", with: "fogel@aol.com"
      fill_in "Password", with: "password"
      fill_in "Confirm Password", with: "password"
      click_on "Create Account"

      expect(current_path).to eq(profile_path(User.last))

      expect(page).to have_content("Thanks for Registering")
      expect(page).to have_content("You are now Logged in McLovin'")


    end
  end
end
