module GreatSchools
  class District
    attr_accessor :nces_code, :name, :district_rating, :address, :phone, :fax, :website, :grade_range, :total_schools,
                  :elmentary_schools, :middle_schools, :high_schools, :public_schools, :charter_schools

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
      def browse

      end
    end
  end
end
