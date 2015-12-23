require 'json'
require 'date'

@data = JSON.parse( IO.read('data.json') )
@output = {'rentals' => []}

def get_rental_price(rental)
  # Get the rental details
  start_date = Date.parse(rental['start_date']).mjd
  end_date = Date.parse(rental['end_date']).mjd
  distance = rental['distance']
  car_id = rental['car_id']

  # Get the car data from the rental details
  unless car = @data['cars'].find {|hash| hash['id'] == car_id}
    raise "Cannot find the car with id=#{car_id}"
  end

  # Get the duration of the rental
  duration = (end_date - start_date) + 1

  # Return the price for the rental
  (duration * car['price_per_day']) + (distance * car['price_per_km'])
end

@data['rentals'].each do |rental|
  @output['rentals'].push('id' => rental['id'], 'price' => get_rental_price(rental));
end

File.open("output2.json","w") do |f|
  f.write(JSON.pretty_generate(@output))
end
