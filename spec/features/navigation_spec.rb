require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'Merchants'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        click_link 'Home'
      end

      expect(current_path).to eq(root_path)

      within 'nav' do
        click_link 'Login'
      end

      expect(current_path).to eq(login_path)

      within 'nav' do
        click_link 'Register'
      end

      expect(current_path).to eq(register_path)

      within 'nav' do
        click_link 'Cart: 0'
      end

      expect(current_path).to eq(cart_path)
    end

    it 'I see a cart indicator in my nav bar' do
      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end
  end
end
