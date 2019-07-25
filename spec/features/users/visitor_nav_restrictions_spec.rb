require "rails_helper"

describe "Visitor Navigation Restrictions" do
  context "as a vistor" do
    it "I do not have access to the following three paths" do

      visit '/merchant/dashboard'
      expect(page).to have_content("404: The page you were looking for doesn't exist")

      visit '/profile'
      expect(page).to have_content("404: The page you were looking for doesn't exist")

      visit '/admin/dashboard'
      expect(page).to have_content("404: The page you were looking for doesn't exist")
    end
  end
end
