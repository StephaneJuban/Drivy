require_relative '../level1/drivy.rb'


module Drivy
  class Rental
    # Calculate the discount according to the rental duration
    def discount
      case self.duration
      when 1
        # No discount for less than 1 day
        return  self.car.price_per_day
      when 2..4
        # Price decreases after 1 day by 10%
        return  self.car.price_per_day +
                ( (self.duration - 1) * (self.car.price_per_day * 0.9).round )
      when 5..10
        # Price decreases after 4 days by 30%
        return  self.car.price_per_day +
                ( 3 * (self.car.price_per_day * 0.9).round ) +
                ( (self.duration - 4) * (self.car.price_per_day * 0.7).round )
      else
        # Price decreases after 10 days by 50%
        return  self.car.price_per_day +
                ( 3 * (self.car.price_per_day * 0.9).round ) +
                ( 6 * (self.car.price_per_day * 0.7).round ) +
                ( (self.duration - 10) * (self.car.price_per_day * 0.5).round )
      end
    end

    # [OVERRIDE] Get the price related to the duration and the discount of the rental
    def duration_price
      return self.discount
    end

  end
end
