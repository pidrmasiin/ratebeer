require 'rails_helper'
require 'helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
  it "ratings page include info about ratings" do
    user2 = FactoryBot.create(:user,username: 'kalle')
    user3 = FactoryBot.create(:user,username: 'palle')
    FactoryBot.create(:rating, user: user2)
    FactoryBot.create(:rating, user: user3)
    visit ratings_path
    expect(page).to have_content "How many ratings totally: " + Rating.count.to_s
    # expect(page).to have_selector('li', count: Rating.count)
  end

end