# For parsing and generate JSON file
require 'json'
# To manipulate rental's dates
require 'date'
# To generate the output file
require 'fileutils'
# For colorful outputs for tests
require 'colorize'


# This is our main module that contains everything
module Drivy
  ##############################################################################
  # Module variables
  ##############################################################################

  # Contains the JSON file parsed
  @@data = nil
  # List of cars
  @@cars = Array.new
  # List of rentals
  @@rentals = Array.new


  ##############################################################################
  # Classes
  ##############################################################################

  # Reprensent a car with its arguments
  class Car
    attr_accessor :id, :price_per_day, :price_per_km

    def initialize(args)
      args.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end


  # Reprensent a rental with its argument. A rental is associated to one car
  # thanks to the car_id we return directly the car object to simulate a
  # belongs_to.
  # We also split the price into multiple sub-method to be more flexible with
  # the next levels.
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

    # Get the price related to the duration of the rental
    def duration_price
      return self.duration * self.car.price_per_day
    end

    # Get the price related to the distance of the rental
    def distance_price
      return self.distance * self.car.price_per_km
    end

    # Return the price of the rental
    def price
      duration_price + distance_price
    end
  end


  ##############################################################################
  # Module methods
  ##############################################################################

  # Load the data (cars & rentals) from a JSON file according to the level
  def self.load(level)
    @@data = JSON.parse( IO.read("level#{level}/data.json") )

    @@data['cars'].each do |car|
      @@cars[car['id']] = Car.new(car)
    end

    @@data['rentals'].each do |rental|
      @@rentals[rental['id']] = Rental.new(rental)
    end
  end

  # Return the parsed data
  def self.data
    @@data
  end

  # Return the car list
  def self.cars
    @@cars
  end

  # Return the rental list
  def self.rentals
    @@rentals
  end

  # Generate the output
  def self.output
    output = {'rentals' => []}

    self.rentals.each do |rental|
      output['rentals'].push('id' => rental.id, 'price' => rental.price) unless rental.nil?
    end

    return output
  end

  # Save the ouput into a file associated to the level
  def self.save(level)
    self.output

    File.open("level#{level}/output2.json","w") do |f|
      f.write(JSON.pretty_generate(output))
    end
  end

  # Test the generated file and the desirated file
  def self.test(level)
    if FileUtils.compare_file("level#{level}/output.json", "level#{level}/output2.json")
      puts "[Level #{level}] OK".green
    else
      puts "[Level #{level}] KO".red
    end
  end
end
