require 'rails_helper'

describe "BeermappingApi" do
  describe "in case of cache miss" do
    before :each do
      Rails.cache.clear
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do
      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end

    it "When HTTP GET returns many entries, all are parsed and returned" do
      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18847</id><name>Keuda</name><status>Brewery</status><reviewlink>https://beermapping.com/location/18847</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18847&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18847&amp;d=1&amp;type=norm</blogmap><street>Puistokatu 4</street><city>Savonlinna</city><state></state><zip>57100</zip><country>Finland</country><phone></phone><overall>0</overall><imagecount>0</imagecount></location><location><id>21534</id><name>Mustan virran panimo</name><status>Brewery</status><reviewlink>https://beermapping.com/location/21534</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21534&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21534&amp;d=1&amp;type=norm</blogmap><street>Laivamiehentie 5</street><city>Savonlinna</city><state>Ita-Suomen Laani</state><zip>57510</zip><country>Finland</country><phone>+358505638764</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>21551</id><name>Waahto Brewery</name><status>Brewery</status><reviewlink>https://beermapping.com/location/21551</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21551&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21551&amp;d=1&amp;type=norm</blogmap><street>Puistokatu 4</street><city>Savonlinna</city><state>Ita-Suomen Laani</state><zip>57100</zip><country>Finland</country><phone>+358 44 0109065</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*savonlinna/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("savonlinna")

      expect(places.size).to eq(3)
      place = places.first
      expect(place.name).to eq("Keuda")
      expect(place.street).to eq("Puistokatu 4")
    end

    it "When HTTP GET does not return any entry, empty set is returned" do
      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>  
      END_OF_STRING

      stub_request(:get, /.*vantaa/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("vantaa")

      expect(places.size).to eq(0)
    end    
  end

  describe "in case of cache hit" do
    before :each do
      Rails.cache.clear   
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do
      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      BeermappingApi.places_in("turku")
      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end

    it "When HTTP GET returns many entries, all are parsed and returned" do
      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18847</id><name>Keuda</name><status>Brewery</status><reviewlink>https://beermapping.com/location/18847</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18847&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18847&amp;d=1&amp;type=norm</blogmap><street>Puistokatu 4</street><city>Savonlinna</city><state></state><zip>57100</zip><country>Finland</country><phone></phone><overall>0</overall><imagecount>0</imagecount></location><location><id>21534</id><name>Mustan virran panimo</name><status>Brewery</status><reviewlink>https://beermapping.com/location/21534</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21534&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21534&amp;d=1&amp;type=norm</blogmap><street>Laivamiehentie 5</street><city>Savonlinna</city><state>Ita-Suomen Laani</state><zip>57510</zip><country>Finland</country><phone>+358505638764</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>21551</id><name>Waahto Brewery</name><status>Brewery</status><reviewlink>https://beermapping.com/location/21551</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21551&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21551&amp;d=1&amp;type=norm</blogmap><street>Puistokatu 4</street><city>Savonlinna</city><state>Ita-Suomen Laani</state><zip>57100</zip><country>Finland</country><phone>+358 44 0109065</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*savonlinna/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      BeermappingApi.places_in("savonlinna")
      places = BeermappingApi.places_in("savonlinna")

      expect(places.size).to eq(3)
      place = places.first
      expect(place.name).to eq("Keuda")
      expect(place.street).to eq("Puistokatu 4")
    end

    it "When HTTP GET does not return any entry, empty set is returned" do
      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>  
      END_OF_STRING

      stub_request(:get, /.*vantaa/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      BeermappingApi.places_in("vantaa")
      places = BeermappingApi.places_in("vantaa")

      expect(places.size).to eq(0)
    end        
  end

end