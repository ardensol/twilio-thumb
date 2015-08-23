json.array!(@quotes) do |quote|
  json.extract! quote, :id, :name, :quote_type, :type_of_home, :recurrence, :day_preference, :time_preference, :bedrooms, :bathrooms, :square_feet, :cleaning_supplies, :eco_friendly, :laundry, :pets, :refrigerator, :oven, :windows, :location, :request_time
  json.url quote_url(quote, format: :json)
end
