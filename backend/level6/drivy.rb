require_relative '../level5/drivy.rb'


module Drivy
  # List of modifications
  @@modifications = Array.new

  # A modification is associated to a rental
  class Modification
    attr_accessor :id, :rental_id, :start_date, :end_date, :distance

    def initialize(args)
      args.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end


  class Rental
    # Create a new attribute to check if there is a modification for this rental
    attr_accessor :rental_modification

    # All the actions needed to generate a rental
    def processing
      # Calculate the commissions fees for every rentals
      self.calculate_commissions

      # Apply options on the rental if needed
      self.apply_options

      # Generate the actions needed for the rental
      self.generate_actions
    end

    # If associated to a modification, return the ID, else return false
    def modification_id
      self.rental_modification || false
    end

    # Get the modification associated to this rental
    def modification
      modification = Drivy.modifications[self.modification_id]

      # Return the modification unless ID doesn't match
      modification unless modification.id != self.modification_id
    end

    # Update the rental according to the modification associated
    def update
      # Create the new rental with the modification applied
      new_rental_attr = {
        :id                   => self.id,
        :car_id               => self.car_id,
        :start_date           => self.modification.start_date           || self.start_date,
        :end_date             => self.modification.end_date             || self.end_date,
        :distance             => self.modification.distance             || self.distance,
        :deductible_reduction => self.deductible_reduction
      }

      # Create the new (temporary) rental
      new_rental = Rental.new(new_rental_attr)
      new_rental.processing

      # Check the difference between the old and the new rental & update the fields
      self.actions.zip(new_rental.actions).map do |old_action, new_action|
        # Do we need to refund ? If yes change the type
        if new_action.amount < old_action.amount
          old_action.type = ( old_action.type == "debit" ? "credit" : "debit")
        end

        # Update the amount
        old_action.amount = (old_action.amount - new_action.amount).abs
      end

    end
  end


  # [OVERRIDE] Load the data (cars, rentals & modifications) from a JSON file
  def self.load(level)
    @@data = JSON.parse( IO.read("level#{level}/data.json") )

    @@data['cars'].each do |car|
      @@cars[car['id']] = Car.new(car)
    end

    @@data['rentals'].each do |rental|
      @@rentals[rental['id']] = Rental.new(rental)
    end

    @@data['rental_modifications'].each do |modification|
      @@modifications[modification['id']] = Modification.new(modification)
      # Record that we have a modification
      @@rentals[modification['rental_id']].rental_modification = modification['id']
    end
  end


  # Return the list of modifications
  def self.modifications
    @@modifications
  end


  # [OVERRIDE] Generate the output
  def self.output
    output = {'rental_modifications' => []}

    self.rentals.each do |rental|
      unless rental.nil?
        # Generate all the process of a rental (commission, options, actions)
        rental.processing

        # Check if there is a modification for this rental
        if rental.modification_id

          # Modify the rental according to the change
          rental.update

          # Generate the output format
          output['rental_modifications'].push(
                                  'id'          =>  rental.modification_id,
                                  'rental_id'   =>  rental.id,
                                  'actions'     =>  rental.print_actions
                                )
        end
      end
    end

    return output
  end

end
