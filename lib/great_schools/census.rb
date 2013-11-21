module GreatSchools #:nodoc:
  class Census < Model
    attr_accessor :school_name, :address, :latitude, :longitude, :phone, :type, :district, :enrollment
    attr_accessor :free_and_reduced_price_lunch, :student_teacher_ratio, :ethnicities

    class << self # Class methods
      # = School Census Data
      #
      # Returns census and profile data for a school.
      # * state - Two letter state abbreviation
      # * id    - Numeric id of school. This gsID is included in other listing requests like Browse Schools and Nearby Schools
      def for_school(state, id)
        response = GreatSchools::API.get("school/census/#{state.upcase}/#{id}")

        new(response)
      end
    end

    def ethnicities=(params)
      @ethnicities = []

      params = params['ethnicity'] if params.is_a?(Hash) && params.key?('ethnicity')

      Array.wrap(params).each do |hash|
        @ethnicities << GreatSchools::Ethnicity.new(hash)
      end

      @ethnicities
    end
  end
end
