module GreatSchools #:nodoc:
  class Score < Model
    attr_accessor :school_name, :rank, :tests

    class << self # Class methods
      # = School Test Scores
      #
      # Returns test and rank data for a specific school.
      # * state - Two letter state abbreviation
      # * id    - Numeric id of school. This gsID is included in other listing requests like Browse Schools and Nearby Schools
      def for_school(state, id)
        response = GreatSchools::API.get("school/tests/#{state.upcase}/#{id}")

        new(response)
      end
    end

    def rank=(hash)
      @rank = GreatSchools::Rank.new(hash)
    end

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
