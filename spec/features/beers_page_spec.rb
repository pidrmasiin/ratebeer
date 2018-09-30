require 'rails_helper'

describe "Beer page" do

      it "do not create beer if name value is empty" do
        visit new_beer_path
        puts page.html
        fill_in('beer_name', with:'')
        click_button('Create Beer')
        expect(page).to have_content "Name can't be blank"
      end
      it "when beer created with good credentials, is added to the system" do
        FactoryBot.create :brewery
        visit new_beer_path
        fill_in('beer_name', with:'Olut')
      
        expect{
          click_button('Create Beer')
        }.to change{Beer.count}.by(1)
      end
  
  end