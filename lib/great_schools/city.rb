module GreatSchools
  class City
    attr_accessor :name, :rating, :total_schools, :elementary_schools, :middle_schools,
                  :high_schools, :public_schools, :charter_schools, :private_schools

    # # City
    # * name
    # * rating
    # * totalSchools
    # * elementarySchools
    # * middleSchools
    # * highSchools
    # * publicSchools
    # * charterSchools
    # * privateSchools
    class << self
      # ### Nearby Cities
      #
      # Returns a list of cities near another city.
      def nearby

      end

      # ### City Overview
      #
      # Returns information about a city.
      def overview

      end
    end

    # ### School Reviews
    #
    # Returns a list of the most recent reviews for a school or for any schools in a city.
    def reviews

    end
  end
end
