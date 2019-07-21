require 'rails_helper'

RSpec.describe "Merchant Profile Show Page" do
  describe 'as a merchant' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @emily = @megan.users.create!(name: "Emily", role: 2, email: "mm@email.com", password: "password", address: "Street", city: "City", state: "ST", zip: 87654)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@emily)
    end

    it "I see my profile details, but cannot edit them" do
      visit merchant_dashboard_show_path

      expect(page).to have_content("Name: #{@megan.name}")
      expect(page).to have_content("Street Address: #{@megan.address}")
      expect(page).to have_content("City: #{@megan.city}")
      expect(page).to have_content("State: #{@megan.state}")
      expect(page).to have_content("Zip: #{@megan.zip}")

      expect(page).to_not have_link("Edit Profile")
      expect(page).to_not have_button("Edit Profile")
    end
  end
end
