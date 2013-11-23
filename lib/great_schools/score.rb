module GreatSchools # :nodoc:
  # = GreatSchools Score
  class Score < Model
    attr_accessor :school_name, :rank, :tests

    class << self # Class methods
      # Returns test and rank data for a specific school.
      #
      # ==== Attributes
      #
      # * +state+ - Two letter state abbreviation
      # * +id+    - Numeric id of a school. This GreatSchools ID is included in
      #             other listing requests like +GreatSchools::School#browse+
      #             and +GreatSchools::School#nearby+
      def for_school(state, id)
        response = GreatSchools::API.get("school/tests/#{state.upcase}/#{id}")

        new(response)
      end
    end

    # Set the +GreatSchools::Rank+.
    #
    # ==== Attributes
    #
    # * +params+ - a +Hash+ of +GreatSchools::Rank+ attributes.
    def rank=(params)
      @rank = GreatSchools::Rank.new(params)
    end

    # Set an array of +GreatSchools::Test+.
    #
    # ==== Attributes
    #
    # * +params+ - a +Hash+ or +Array+ of +GreatSchools::Test+ attributes.
    def tests=(params)
      @tests = []

      Array.wrap(params).each do |hash|
        @tests << GreatSchools::Test.new(hash)
      end

      @tests
    end
    alias_method :test=, :tests=
  end
end
