module GreatSchools
  class City < Model
    attr_accessor :name, :state, :rating, :total_schools
    attr_accessor :elementary_schools, :middle_schools, :high_schools
    attr_accessor :public_schools, :charter_schools, :private_schools

    class << self # Class methods
      # ### Nearby Cities
      #
      # Returns a list of cities near another city.
      # * state - Two letter state abbreviation
      # * city  - Name of city, with spaces replaced with hyphens. If the city name has hyphens, replace those with underscores. Any other special characters should be URL-encoded
      # * radius  - Radius in miles to confine search to. Defaults to 15 and can be in the range 1-100.
      # * sort    - How to sort the results. Defaults to "distance". Other options are "name" to sort by city name in alphabetical order, and "rating" to sort by GS city rating, highest first.
      def nearby(state, city, radius = 15, sort = 'distance')
        # TODO validate radius in range 1-100
        # TODO validate sort one of: distance, name, or rating

        results = GreatSchools::API.get("cities/nearby/#{state.upcase}/#{parameterize(city)}", radius: radius, sort: sort)

        cities = results.fetch('cities', {}).fetch('city')
        cities = [cities] unless cities.is_a?(Array)

        cities.map {|city| new(city.merge(state: state)) }
      end

      # ### City Overview
      #
      # Returns information about a city.
      # * state - Two letter state abbreviation
      # * city  - Name of city, with spaces replaced with hyphens. If the city name has hyphens, replace those with underscores. Any other special characters should be URL-encoded
      def overview(state, city)
        results = GreatSchools::API.get("cities/#{state.upcase}/#{parameterize(city)}")

        new(results.fetch('city', {}).merge(state: state))
      end
    end

    # ### School Reviews
    #
    # Returns a list of the most recent reviews for a school or for any schools in a city.
    # * state       - Two letter state abbreviation
    # * city        - Name of city, with spaces replaced with hyphens. If the city name has hyphens, replace those with underscores.
    # * cutoff_age  - Reviews must have been published after this many days ago to be returned. Only valid for the recent reviews in a city call.
    # * limit       - Maximum number of reviews to return. This defaults to 5.
    def reviews(cutoff_age = nil, limit = 5)
      GreatSchools::Review.for_city(state, name, cutoff_age, limit)
    end
  end
end
