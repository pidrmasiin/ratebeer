require "rails_helper"


RSpec.describe User, type: :model do
  before :each do
    FactoryBot.create :style
  end
  it "if beer has name,style and brewery it can be stored" do
    brewery = Brewery.create name: "Panimo", year:1400
    beer = FactoryBot.create :beer, brewery: brewery
    puts beer
    expect(beer.valid?).to be(true)
    expect(brewery.valid?).to be(true)
    expect(Beer.count).to eq(1)
    expect(Brewery.count).to eq(1)
  end
  it "if beer hasn't name or style it can't be stored" do
    brewery = Brewery.create name: "Panimo", year:1400
    beer = Beer.create brewery: brewery
    beer2 = Beer.create brewery: brewery
    beer3 = Beer.create name:"lager", brewery: brewery

    expect(beer.valid?).to be(false)
    expect(beer2.valid?).to be(false)
    expect(beer3.valid?).to be(false)
    expect(brewery.valid?).to be(true)
    expect(Beer.count).to eq(0)
    expect(Brewery.count).to eq(1)
  end
  
end
