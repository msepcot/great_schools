module GreatSchools
  class District
    attr_accessor :name, :address, :phone, :fax, :website
    attr_accessor :nces_code, :district_rating, :grade_range, :total_schools
    attr_accessor :elmentary_schools, :middle_schools, :high_schools
    attr_accessor :public_schools, :charter_schools

    # # District
    #
    # * ncesCode
    # * name
    # * districtRating
    # * address
    # * phone
    # * fax
    # * website
    # * gradeRange
    # * totalSchools
    # * elementarySchools
    # * middleSchools
    # * highSchools
    # * publicSchools
    # * charterSchools
    class << self
      # ### Browse Districts
      #
      # Returns a list of school districts in a city.
      # * state - Two letter state abbreviation
      # * city  - Name of city, with spaces replaced with hyphens. If the city name has hyphens, replace those with underscores. Any other special characters should be URL-encoded
      def browse(state, city)
        # districts/CA/San-Francisco?key=[yourAPIKey]
        # SAMPLE districts/CA/San-Francisco?key=[yourAPIKey]
      end
    end
  end
end
