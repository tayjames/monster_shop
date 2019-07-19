require 'rails_helper'

RSpec.describe 'User Update' do
  describe 'As a registered user' do
    describe 'when I visit my profile page' do
      before(:each) do
        @user_1 = User.create!(email: "123@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 1)
        @user_2 = User.create!(email: "456@gmail.com", password: "password", name: "PapRica Jones", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 1)
        visit login_path
        fill_in "email", with: "123@gmail.com"
        fill_in "password", with: "password"

        click_button("Login")

        expect(@user_1.role).to eq("registered_user")
        visit user_profile_path(@user_1)
      end

      it "I can edit my profile" do





        visit user_profile_path(@user_1)

        click_button 'Edit Profile'

        expect(current_path).to eq(edit_user_profile_path(@user_1))

        expect(find_field('Name').value).to eq(@user_1.name)
        expect(find_field('Address').value).to eq(@user_1.address)
        expect(find_field('City').value).to eq(@user_1.city)
        expect(find_field('State').value).to eq(@user_1.state)
        expect(find_field('Zip').value).to eq(@user_1.zip.to_s)
        expect(find_field('Email').value).to eq(@user_1.email)

        fill_in "Name", with: "McLovin'"
        fill_in "Address", with: "892 Mamoma St"
        fill_in "City", with: "Honolulu"
        fill_in "State", with: "HI"
        fill_in "Zip", with: 96820
        fill_in "Email", with: "fogel@aol.com"



        click_on 'Update Profile'

        expect(current_path).to eq(user_profile_path(@user_1))

        expect(page).to have_content("Your Profile has been updated.")
        expect(page).to have_content("McLovin'")
        expect(page).to have_content("892 Mamoma St")
        expect(page).to have_content("Honolulu")
        expect(page).to have_content("HI")
        expect(page).to have_content(96820)
        expect(page).to have_content("fogel@aol.com")
      end

      it "I cannot leave fields blank while updating my profile" do

        
        click_button 'Edit Profile'

        fill_in "Name", with: ""
        fill_in "Address", with: ""
        fill_in "City", with: ""
        fill_in "State", with: ""
        fill_in "Zip", with: ""
        fill_in "Email", with: ""

        click_on 'Update Profile'

        expect(current_path).to eq(user_profile_path(@user_1))

        expect(page).to have_content("Email can't be blank, Name can't be blank, Address can't be blank, City can't be blank, State can't be blank, and Zip is not a number")
      end

      it "I can edit my password" do
        click_button 'Edit Password'

        expect(current_path).to eq(edit_password_path(@user_1))

        new_password = 'hellooooo'


        fill_in :password, with: new_password
        fill_in :password_confirmation, with: new_password

        click_button 'Update Password'

        expect(current_path).to eq(user_profile_path(@user_1))
        expect(page).to have_content("Your password has been updated")
      end

      it "My passwords must match" do
        click_button 'Edit Password'

        fill_in :password, with: "newpassword"
        fill_in :password_confirmation, with: "hello"

        click_button 'Update Password'

        expect(current_path).to eq(user_profile_path(@user_1))
        expect(page).to have_content("Password confirmation doesn't match Password")
      end

      it "I cannot update my email to an existing email" do
        click_button 'Edit Profile'

        fill_in "Email", with: "456@gmail.com"

        click_button 'Update Profile'

        expect(page).to have_content("Email has already been taken")
      end
    end
  end
end
