require 'rails_helper'

describe "Admin Navigation Restrictions" do
  context "as a Admin" do
    it "I do not have access to the following three paths" do
      user = User.create!(email: "123@gmail.com", password: "password", name: "Tom", role: 3, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)
      brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

      visit '/'

      click_link 'Login'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password

      click_button 'Login'

      click_on "Merchants"

      click_on "Brians Bagels"


    end
  end
end



# As an admin user
# When I visit the merchant index page ("/merchants")
# And I click on a merchant's name,
# Then my URI route should be ("/admin/merchants/6")
# Then I see everything that merchant would see
