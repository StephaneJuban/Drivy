require 'json'
require 'date'
require 'fileutils'


module Drivy
  @@data = nil
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
      car = Drivy.cars[self.car_id]

      # Return the car unless ID doesn't match
      car unless car.id != self.car_id
    end

    # Get the total duration of the rental
    def duration
      ( Date.parse(self.end_date).mjd - Date.parse(self.start_date).mjd ) + 1
    end

    def price
      (self.duration * self.car.price_per_day) + (self.distance * self.car.price_per_km)
    end
  end


  # Load the data (cars & rentals) from a JSON file
  def self.load_data(filename)
    @@data = JSON.parse( IO.read(filename) )

    @@data['cars'].each do |car|
      @@cars[car['id']] = Car.new(car)
    end

    @@data['rentals'].each do |rental|
      @@rentals[rental['id']] = Rental.new(rental)
    end
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

  def self.save
    output = {'rentals' => []}
    self.rentals.each do |rental|
      output['rentals'].push('id' => rental.id, 'price' => rental.price) unless rental.nil?
    end

    File.open("level1/output2.json","w") do |f|
      f.write(JSON.pretty_generate(output))
    end
  end

  def self.test
    if FileUtils.compare_file('level1/output.json', 'level1/output2.json')
      puts "[Level 1] OK"
    else
      puts "[Level 1] KO"
    end
  end
end



Drivy.load_data("level1/data.json")
Drivy.save
Drivy.test
