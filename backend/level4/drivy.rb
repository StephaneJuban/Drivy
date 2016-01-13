require_relative '../level3/drivy.rb'


module Drivy
  class Rental
    attr_accessor :deductible_reduction, :deductible_reduction_fee

    # Apply options to the rental according to the data
    def apply_options
      # Initialize
      self.deductible_reduction_fee = 0

      # If the driver subscribed to the deductible reduction option
      if self.deductible_reduction
        self.deductible_reduction_fee = self.duration * 400
      end

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

        # Generate the output format
        output['rentals'].push(
                                'id'          =>  rental.id,
                                'price'       =>  rental.price,
                                'options'     =>  {
                                                    'deductible_reduction' => rental.deductible_reduction_fee
                                                  },
                                'commission'  =>  {
                                                    'insurance_fee'   => rental.insurance_fee,
                                                    'assistance_fee'  => rental.assistance_fee,
                                                    'drivy_fee'       => rental.drivy_fee
                                                  }
                              )
      end
    end

    return output
  end

end
