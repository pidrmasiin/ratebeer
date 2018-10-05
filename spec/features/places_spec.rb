require 'rails_helper'

describe "Places" do

  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many are returned by the API, all are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ), Place.new( name:"Herkkuhaarukka", id: 2 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Herkkuhaarukka"
  end

  it "if none are returned by the API, the info is shown" do
    allow(BeermappingApi).to receive(:places_in).with("d").and_return(
      [ ]
    )
    visit places_path
    fill_in('city', with: 'd')
    click_button "Search"
    expect(page).to have_content "No locations in d"
  end

end