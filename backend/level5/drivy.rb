require_relative '../level4/drivy.rb'


module Drivy
  class Action
    attr_accessor :who, :type, :amount

    def initialize(args)
      args.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end

  class Rental
    attr_accessor :actions

    # Sum the commissions
    def total_commissions
      return self.insurance_fee + self.assistance_fee + self.drivy_fee
    end

    # Generate the actions needed for the rental
    def generate_actions
      self.actions = Array.new

      self.actions << Action.new(:who => "driver",      :type => "debit",   :amount => (self.price + self.deductible_reduction_fee))
      self.actions << Action.new(:who => "owner",       :type => "credit",  :amount => (self.price - self.total_commissions))
      self.actions << Action.new(:who => "insurance",   :type => "credit",  :amount => self.insurance_fee)
      self.actions << Action.new(:who => "assistance",  :type => "credit",  :amount => self.assistance_fee)
      self.actions << Action.new(:who => "drivy",       :type => "credit",  :amount => (self.drivy_fee + self.deductible_reduction_fee))

      return self.actions
    end
  end

  # [OVERRIDE] Generate the output
  def self.output
    output = {'rentals' => []}

    self.rentals.each do |rental|
      unless rental.nil?
        # Calculate the commissions fees for every rentals
        rental.calculate_commissions

        # Apply options on the rental if needed
        rental.apply_options

        # Generate the actions needed for the rental
        rental.generate_actions

        # Format the actions to the desired format
        actions = Array.new
        rental.actions.each do |action|
          actions.push('who' => action.who, 'type' => action.type, 'amount' => action.amount)
        end

        # Generate the output format
        output['rentals'].push(
                                'id'          =>  rental.id,
                                'actions'     =>  actions
                              )
      end
    end

    return output
  end

end
