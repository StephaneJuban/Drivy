require_relative '../level2/drivy.rb'


module Drivy
  class Rental
    attr_accessor :insurance_fee, :assistance_fee, :drivy_fee

    # Get the commissions associated to this rental
    def calculate_commissions
      # We take 30% of the final price
      commission = (self.price * 0.3).round

      # We split this commission into fees
      # Half goes to the insurance
      self.insurance_fee  = (commission * 0.5).round
      # 1€/day goes to the roadside assistance. Is it not 100€ instead of 1€ ?
      self.assistance_fee = self.duration * 100
      # The rest goes to us
      self.drivy_fee      = commission - self.insurance_fee - self.assistance_fee
    end
  end


  # [OVERRIDE] Generate the output
  def self.output
    output = {'rentals' => []}

    self.rentals.each do |rental|
      unless rental.nil?
        # Calculate the commissions fees for every rentals
        rental.calculate_commissions

        # Generate the output format
        output['rentals'].push(
                                'id' => rental.id,
                                'price' => rental.price,
                                'commission' => {
                                                  'insurance_fee' => rental.insurance_fee,
                                                  'assistance_fee' => rental.assistance_fee,
                                                  'drivy_fee' => rental.drivy_fee
                                                }
                              )
      end
    end

    return output
  end

end
