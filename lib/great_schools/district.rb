module GreatSchools
  class District < Model
    attr_accessor :name, :address, :phone, :fax, :website
    attr_accessor :nces_code, :district_rating, :grade_range, :total_schools
    attr_accessor :elementary_schools, :middle_schools, :high_schools
    attr_accessor :public_schools, :charter_schools

    class << self # Class methods
      # Returns a list of school districts in a city.
      #
      # +state+ is the two letter state abbreviation.
      # +city+ is the name of the city.
      def browse(state, city)
        response = GreatSchools::API.get("districts/#{state.upcase}/#{parameterize(city)}")

        districts = response.fetch('districts', {}).fetch('district')
        districts = [districts] unless districts.is_a?(Array)

        districts.map {|district| new(district) }
      end
    end
  end
end
