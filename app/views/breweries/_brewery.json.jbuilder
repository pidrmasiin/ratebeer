json.extract! brewery, :id, :name, :year, :created_at, :updated_at, :beers
json.url brewery_url(brewery, format: :json)
