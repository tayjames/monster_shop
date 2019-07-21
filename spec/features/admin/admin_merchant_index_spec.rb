require "rails_helper"

RSpec.describe "Admin Merchant Index Page" do
  describe "As an admin user" do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: false)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user_1 = User.create!(email: "1234@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 3)
      @user_2 = User.create!(email: "12345@gmail.com", password: "password", name: "Parsley Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 3)
    end

    it "I see merchant's city and state next to their name" do


      visit login_path

      fill_in 'Email', with: @user_1.email
      fill_in 'Password', with: @user_1.password
      click_button 'Login'

      visit '/merchants'
      # save_and_open_page

      expect(page).to have_content(@megan.city)
      expect(page).to have_content(@megan.state)
    end

    it "I see a disable/enable button next to any merchants whose accts are enabled/disabled" do
      visit login_path

      fill_in 'Email', with: @user_1.email
      fill_in 'Password', with: @user_1.password
      click_button 'Login'

      visit '/merchants'

      expect(@megan.enabled).to eq(false)

      within "#merchant-#{@megan.id}" do
        expect(page).to have_button("Enable")
        expect(page).to_not have_button("Disable")
        click_button "Enable"
      end
      expect(current_path).to eq(merchants_path)
      save_and_open_page
      expect(@megan.reload.enabled).to eq(true)
      expect(page).to have_content("#{@megan.name} has been enabled")
    end

    it "I see a disable/enable button next to any merchants whose accts are enabled/disabled" do
      visit login_path

      fill_in 'Email', with: @user_2.email
      fill_in 'Password', with: @user_2.password
      click_button 'Login'
      visit '/merchants'

      expect(@brian.enabled).to eq(true)

      within "#merchant-#{@brian.id}" do
        expect(page).to have_button("Disable")
        expect(page).to_not have_button("Enable")
        click_button 'Disable'
      end
      expect(current_path).to eq(merchants_path)
      expect(@brian.reload.enabled).to eq(false)
      expect(page).to have_content("#{@brian.name} has now been disabled")
    end
  end
end
