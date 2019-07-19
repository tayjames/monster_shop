require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Item Index Page' do
  describe 'As a visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 6 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 6 )
    end
    it 'I can see a list of all items' do
      visit '/items'

      within "#item-#{@ogre.id}" do
        expect(page).to have_link(@ogre.name)
        expect(page).to have_content(@ogre.description)
        expect(page).to have_content("Price: #{number_to_currency(@ogre.price)}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@ogre.inventory}")
        expect(page).to have_content("Sold by: #{@megan.name}")
        expect(page).to have_css("img[src*='#{@ogre.image}']")
        expect(page).to have_link(@megan.name)
      end

      within "#item-#{@giant.id}" do
        expect(page).to have_link(@giant.name)
        expect(page).to have_content(@giant.description)
        expect(page).to have_content("Price: #{number_to_currency(@giant.price)}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@giant.inventory}")
        expect(page).to have_content("Sold by: #{@megan.name}")
        expect(page).to have_css("img[src*='#{@giant.image}']")
        expect(page).to have_link(@megan.name)
      end

      within "#item-#{@hippo.id}" do
        expect(page).to have_link(@hippo.name)
        expect(page).to have_content(@hippo.description)
        expect(page).to have_content("Price: #{number_to_currency(@hippo.price)}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@hippo.inventory}")
        expect(page).to have_content("Sold by: #{@brian.name}")
        expect(page).to have_css("img[src*='#{@hippo.image}']")
        expect(page).to have_link(@brian.name)
      end
    end

    it "I can see only enabled items and image is a link to item's page" do
      @ogre_2 = @megan.items.create!(name: 'Ogre the Voyager', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 5 )
      @hippo_2 = @brian.items.create!(name: 'Pippo the Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )

      visit items_path

      expect(page).to have_content(@ogre.name)
      expect(page).to have_content(@giant.name)
      expect(page).to have_content(@hippo.name)

      expect(page).to_not have_content(@ogre_2.name)
      expect(page).to_not have_content(@hippo_2.name)

      visit merchant_items_path(@megan)

      expect(page).to have_content(@ogre.name)
      expect(page).to_not have_content(@ogre_2.name)

      visit merchant_items_path(@brian)

      expect(page).to have_content(@hippo.name)
      expect(page).to_not have_content(@hippo_2.name)

      visit items_path

      within "#item-#{@ogre.id}" do
        find("img[src*='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw']").click
      end

      expect(page).to have_content(@ogre.description)

      within "#item-#{@giant.id}" do
        find("img[src*='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw']").click
      end

      expect(page).to have_content(@giant.description)
    end

    it "I see an area with statistics" do
      @ogre_2 = @megan.items.create!(name: 'Ogre the Voyager', description: "I'm a Stinky Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 12 )
      @hippo_2 = @brian.items.create!(name: 'Pippo the Hippo', description: "I'm a Peppy Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 14 )
      @giant_2 = @megan.items.create!(name: 'Bryan the Giant', description: "I'm a named Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 30 )
      @user = User.create!(email: "email@email.com", password: "password", name: "Mellie", address: "Streeterville", city: "Riot", state: "WA", zip: 98765)
      @order_1 = @user.orders.create!(name: 'Megan M', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @order_2 = @user.orders.create!(name: 'Megan M', address: '123 Main St', city: 'Denver', state: 'IA', zip: 80218)
      @order_3 = @user.orders.create!(name: 'Megan M', address: '123 Main St', city: 'Denver', state: 'IA', zip: 80218)
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 4)
      @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3)
      @order_2.order_items.create!(item: @giant, price: @giant.price, quantity: 2)
      @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_2.order_items.create!(item: @hippo_2, price: @hippo_2.price, quantity: 11)
      @order_3.order_items.create!(item: @ogre_2, price: @ogre_2.price, quantity: 5)
      @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 8)

      visit items_path

      within ".item_stats" do
        expect(page).to have_content("Top 5 Items")
      end
      within ".item_stats" do
        expect(page).to have_content("Least Purchased 5 Items")
      end
    end
  end
end
# - the top 5 most popular items by quantity purchased, plus the quantity bought
# - the bottom 5 least popular items, plus the quantity bought
#
# "Popularity" is determined by total quantity of that item ordered
