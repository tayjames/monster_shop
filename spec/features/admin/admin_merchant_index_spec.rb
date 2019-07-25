require "rails_helper"

RSpec.describe "Admin Merchant Index Page" do
  describe "As an admin user" do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: false)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

      @user_1 = User.create!(email: "1234@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 3)
      @user_2 = User.create!(email: "12345@gmail.com", password: "password", name: "Parsley Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 3)

      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
    end

    it "I see merchant's city and state next to their name" do

      visit login_path

      fill_in 'Email', with: @user_1.email
      fill_in 'Password', with: @user_1.password
      click_button 'Login'

      visit admin_merchants_path

      expect(page).to have_content(@megan.city)
      expect(page).to have_content(@megan.state)
    end

    it "I see a disable/enable button next to any merchants whose accts are enabled/disabled" do
      visit login_path

      fill_in 'Email', with: @user_1.email
      fill_in 'Password', with: @user_1.password
      click_button 'Login'

      visit admin_merchants_path

      expect(@megan.enabled).to eq(false)
      expect(@giant.active).to eq(false)
      expect(@ogre.active).to eq(false)

      within "#merchant-#{@megan.id}" do
        expect(page).to have_button("Enable")
        expect(page).to_not have_button("Disable")
        click_button "Enable"
      end
      expect(current_path).to eq(admin_merchants_path)
      expect(@megan.reload.enabled).to eq(true)
      expect(@giant.reload.active).to eq(true)
      expect(@ogre.reload.active).to eq(true)
      expect(page).to have_content("#{@megan.name} has been enabled")
    end

    it "I see a disable/enable button next to any merchants whose accts are enabled/disabled" do
      visit login_path

      fill_in 'Email', with: @user_2.email
      fill_in 'Password', with: @user_2.password
      click_button 'Login'
      visit admin_merchants_path

      expect(@brian.enabled).to eq(true)
      expect(@hippo.active).to eq(true)

      within "#merchant-#{@brian.id}" do
        expect(page).to have_button("Disable")
        expect(page).to_not have_button("Enable")
        click_button 'Disable'
      end

      expect(current_path).to eq(admin_merchants_path)
      expect(@brian.reload.enabled).to eq(false)
      expect(@hippo.reload.active).to eq(false)
      expect(page).to have_content("#{@brian.name} has now been disabled")
    end
  end
end
