require 'rails_helper'
require 'helper'

include Helpers

describe "User" do
  before :each do
    FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end
  describe "user ratings" do
    let(:user2) { FactoryBot.create(:user, username: "Kalle") }
    let(:user3) { FactoryBot.create(:user, username: "Jalle") }
    let(:beerbe) { FactoryBot.create(:beer, name: 'beerbee', style: 'Porter') }

    before :each do
        # jotta muuttuja näkyisi it-lohkoissa, tulee sen nimen alkaa @-merkillä
        FactoryBot.create(:rating, user: user2)
        FactoryBot.create(:rating, beer: beerbe, user: user2)
        sign_in(username: "Kalle", password: "Foobar1")
        end
    it "list of user ratings" do
        FactoryBot.create(:rating, user: user3)
        expect(page).to have_selector('li', count: user2.ratings.count)
        expect(Rating.count).to be > user2.ratings.count 
    end

    it "erase user rating" do
        expect{
            click_link('1')
          }.to change{user2.ratings.count}.from(2).to(1)
    end

    it "show favorite brewery and style" do
        puts page.html
        expect(page).to have_content 'Favorite style = Porter'
        expect(page).to have_content 'Favorite brewery = anonymous'
    end

    
  end
end