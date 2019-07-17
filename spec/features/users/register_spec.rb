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

    it "I must fill in all fields" do
      visit register_path

      click_on "Create Account"
      expect(current_path).to eq(profile_path)

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Address can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("State can't be blank")
      expect(page).to have_content("Zip is not a number")
      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Password can't be blank")
    end

    it "I cannot use an email already in the system" do
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

      expect(current_path).to eq(profile_path)
      # save_and_open_page
      expect(page).to have_content("Email has already been taken")
      expect(find_field('Name').value).to eq("McLovin'")
      expect(find_field('Address').value).to eq("892 Mamoma St")
      expect(find_field('City').value).to eq("Honolulu")
      expect(find_field('State').value).to eq("HI")
      expect(find_field('Zip').value).to eq("96820")
    end
  end
end
