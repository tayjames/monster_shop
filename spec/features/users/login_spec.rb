require "rails_helper"

RSpec.describe "User Login" do
  describe "As a visitor" do
    it "When I visit the login path I see a field to enter my email address and password" do
      # binding.pry
      visitor = User.create!(email: "123@gmail.com", password: "password", name: "Tom", role: 0, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)
      # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit login_path
      fill_in "email", with: "123@gmail.com"
      fill_in "password", with: "password"

      click_button("Login")

      expect(visitor.role).to eq("visitor")
      visit profile_path(visitor)
      expect(page).to have_content("You are now Logged in #{visitor.name}")
    end

    it "When I visit the login path I see a field to enter my email address and password" do
      # binding.pry
      user = User.create!(email: "123@gmail.com", password: "password", name: "Tom", role: 1, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)
      # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit login_path
      fill_in "email", with: "123@gmail.com"
      fill_in "password", with: "password"

      click_button("Login")

      expect(user.role).to eq("registered_user")
      expect(current_path).to eq(profile_path)
      expect(page).to have_content("You are now Logged in #{user.name}")
    end

    it "If I am a merchant user, I am redirected to my merchant dashboard page" do
      merchant = User.create!(email: "123@gmail.com", password: "password", name: "Tom", role: 2, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)

      visit login_path
      fill_in "email", with: "123@gmail.com"
      fill_in "password", with: "password"

      click_button("Login")

      expect(merchant.role).to eq("merchant")
      expect(current_path).to eq(merchants_dashboard_path)
      expect(page).to have_content("You are now Logged in #{merchant.name}")
    end

    it "If I am a admin user, I am redirected to my admin dashboard page" do
      admin = User.create!(email: "123@gmail.com", password: "password", name: "Tom", role: 3, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)

      visit login_path
      fill_in "email", with: "123@gmail.com"
      fill_in "password", with: "password"

      click_button("Login")


      expect(admin.role).to eq("admin")
      expect(current_path).to eq(admin_dashboard_path)
      expect(page).to have_content("You are now Logged in #{admin.name}")
    end

    it "When I visit the logout path, I am redirected to the root page of the site and I see that my cart has been emptied" do
      visit logout_path

      expect(current_path).to eq(root_path)
      expect(page).to have_content("You are now Logged out.")
      expect(page).to have_content("Cart: 0")
    end
  end
end
