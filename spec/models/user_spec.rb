require "rails_helper"

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end
  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end
  it "username isn't too short" do
    FactoryBot.create(:user)
    user = User.create username: "Pe", password: "Secret1", password_confirmation: "Secret1"
    expect(user.valid?).to be(false)
    expect(User.count).to eq(1)
  end
  it "and passeowrd not contains just characters" do
    FactoryBot.create(:user)
    user =  User.create username: "Pekka", password: "Secret", password_confirmation: "Secret"
    expect(user.valid?).to be(false)
    expect(User.count).to eq(1)
  end
 
 

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }
  
    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end
  
    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)
  
      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end
    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_beer).to eq(beer)
    end
    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25 )

      expect(user.favorite_beer).to eq(best)
    end    
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end
    it "the one is the favorite if only one rating" do
      beer = FactoryBot.create(:beer, style:'lager')
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_style).to eq('lager')
    end
    it "is style with highest ratings is favorite if several rated" do
      create_beers_with_style_and_many_ratings({user: user}, 10, 20, 15, 7, 9, 'lager')
      create_beers_with_style_and_many_ratings({user: user}, 10, 20, 15, 9, 9, 'ipa')
      create_beers_with_style_and_many_ratings({user: user}, 10, 20, 15, 8, 9, 'porter')
      expect(user.favorite_style).to eq("ipa")
    end    
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end
    it "the one is the favorite if only one rating" do
      brewery = FactoryBot.create(:brewery, name: "brewery")
      beer = FactoryBot.create(:beer, brewery: brewery)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
      puts brewery.name
      expect(user.favorite_brewery).to eq('brewery')
    end
    it "is style with highest ratings is favorite if several rated" do
      brewery = FactoryBot.create(:brewery, name: "brewery")
      beer = FactoryBot.create(:beer, brewery: brewery)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
      rating = FactoryBot.create(:rating, score: 50, beer: beer, user: user)
      brewery2 = FactoryBot.create(:brewery, name: "brewery2")
      beer2 = FactoryBot.create(:beer, brewery: brewery2)
      rating = FactoryBot.create(:rating, score: 30, beer: beer2, user: user)
      expect(user.favorite_brewery).to eq("brewery")
    end    
  end

end # describe User

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end

def create_beer_with_style_and_rating(object, score, style)
  beer = FactoryBot.create(:beer, style: style)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beers_with_style_and_many_ratings(object, *scores, style)
  scores.each do |score|
    create_beer_with_style_and_rating(object, score, style)
  end
end
