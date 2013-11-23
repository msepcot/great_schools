module GreatSchools # :nodoc:
  # = GreatSchools Review
  class Review < Model
    attr_accessor :school_name, :school_address
    attr_accessor :review_link, :rating, :submitter, :posted_date, :comments

    class << self # Class methods
      # Returns a list of the most recent reviews for any schools in a city.
      #
      # ==== Attributes
      #
      # * +state+ - Two letter state abbreviation
      # * +city+  - Name of city
      #
      # ==== Options
      #
      # * +:cutoff_age+ - Reviews must have been published after this many days
      #                   ago to be returned.
      # * +:limit+      - Maximum number of reviews to return. This defaults to 5.
      def for_city(state, city, options = {})
        options[:cutoffAge] = options.delete(:cutoff_age) # TODO: make helper method to camelCase or map query attributes

        response = GreatSchools::API.get("reviews/city/#{state.upcase}/#{parameterize(city)}", options.slice(:cutoffAge, :limit))

        Array.wrap(response).map { |review| new(review) }
      end

      # Returns a list of the most recent reviews for a school.
      #
      # ==== Attributes
      #
      # * +state+ - Two letter state abbreviation
      # * +id+    - Numeric id of a school. This GreatSchools ID is included in
      #             other listing requests like +GreatSchools::School#browse+
      #             and +GreatSchools::School#nearby+
      #
      # ==== Options
      #
      # * +:limit+ - Maximum number of reviews to return. This defaults to 5.
      def for_school(state, id, options = {})
        response = GreatSchools::API.get("reviews/school/#{state.upcase}/#{id}", options.slice(:limit))

        Array.wrap(response).map { |review| new(review) }
      end
    end
  end
end
