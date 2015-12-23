require 'json'
require 'date'



module Drivy
  @@data = JSON.parse( IO.read('data.json') )
  @@cars = Array.new
  @@rentals = Array.new


  class Car
    attr_accessor :id, :price_per_day, :price_per_km

    def initialize(args)
      args.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end


  class Rental
    attr_accessor :id, :car_id, :start_date, :end_date, :distance

    def initialize(args)
      args.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

    # Get the car associated to this rental
    def car
      Drivy.cars[self.car_id]
    end

    # Get the total duration of the rental
    def duration
      ( Date.parse(self.end_date).mjd - Date.parse(self.start_date).mjd ) + 1
    end

    def price
      (self.duration * self.car.price_per_day) + (self.distance * self.car.price_per_km)
    end
  end


  @@data['cars'].each do |car|
    @@cars[car['id']] = Car.new(car)
  end

  @@data['rentals'].each do |rental|
    @@rentals[rental['id']] = Rental.new(rental)
  end

  def self.data
    @@data
  end

  def self.cars
    @@cars
  end

  def self.rentals
    @@rentals
  end

  def self.write_output
    output = {'rentals' => []}
    self.rentals.each do |rental|
      output['rentals'].push('id' => rental.id, 'price' => rental.price) unless rental.nil?
    end

    File.open("output2.json","w") do |f|
      f.write(JSON.pretty_generate(output))
    end
  end
end



Drivy.write_output
