require "rails_helper"

RSpec.describe "Admin User Index Page" do
  describe "When I click the 'Users' link in the nav" do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: false)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user_1 = User.create!(email: "1234@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 3)
      @user_2 = User.create!(email: "12345@gmail.com", password: "password", name: "Parsley Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 2)
    end

    it "I see all users in the system" do
      visit login_path

      fill_in 'Email', with: @user_1.email
      fill_in 'Password', with: @user_1.password
      click_button 'Login'

      click_link "All Users"
      expect(page).to have_content(@user_1.name)
      expect(page).to have_content(@user_2.name)

      expect(page).to have_link(@user_1.name)
      expect(page).to have_content(@user_1.created_at)
      expect(page).to have_content(@user_1.role)

      click_link(@user_1.name)
      expect(current_path).to eq("/admin/users/#{@user_1.id}")

      click_link "All Users"
      expect(page).to have_link(@user_2.name)
      expect(page).to have_content(@user_1.created_at)
      expect(page).to have_content(@user_1.role)

      click_link(@user_2.name)
      expect(current_path).to eq("/admin/users/#{@user_2.id}")
    end
  end
end
