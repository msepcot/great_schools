module GreatSchools # :nodoc:
  # = GreatSchools City
  #
  # --
  # TODO: add method to grab nearby schools using +GreatSchools::School#nearby+
  # with the +city+ and +state+ options.
  # ++
  class City < Model
    attr_accessor :name, :state, :rating, :total_schools
    attr_accessor :elementary_schools, :middle_schools, :high_schools
    attr_accessor :public_schools, :charter_schools, :private_schools

    class << self # Class methods
      # Returns a list of cities near another city.
      #
      # ==== Attributes
      #
      # * +state+ - Two letter state abbreviation
      # * +city+  - Name of city
      #
      # ==== Options
      #
      # * +:radius+ - Radius in miles to confine search to. Defaults to 15 and
      #               can be in the range 1-100.
      # * +:sort+   - How to sort the results. Defaults to 'distance'. Other
      #               options are 'name' to sort by city name in alphabetical
      #               order, and 'rating' to sort by GreatSchool city rating,
      #               highest first.
      # --
      # TODO: handle validations
      # ++
      def nearby(state, city, options = {})
        options.slice!(:radius, :sort)

        response = GreatSchools::API.get("cities/nearby/#{state.upcase}/#{parameterize(city)}", options)

        Array.wrap(response).map { |city| new(city.merge(state: state)) }
      end

      # Returns information about a city.
      #
      # ==== Attributes
      #
      # * +state+ - Two letter state abbreviation
      # * +city+  - Name of city
      def overview(state, city)
        response = GreatSchools::API.get("cities/#{state.upcase}/#{parameterize(city)}")

        new(response.merge(state: state))
      end
    end

    alias_method :city, :name
    alias_method :city=, :name=

    # Returns a list of districts in a city.
    def districts
      @districts ||= GreatSchools::District.browse(state, city)
    end

    # Returns a list of the most recent reviews for any schools in a city.
    #
    # ==== Options
    #
    # * +:cutoff_age+ - Reviews must have been published after this many days
    #                   ago to be returned.
    # * +:limit+      - Maximum number of reviews to return. This defaults to 5.
    def reviews(options = {})
      GreatSchools::Review.for_city(state, name, options.slice(:cuttoff_age, :limit))
    end
  end
end
