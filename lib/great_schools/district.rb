module GreatSchools # :nodoc:
  # = GreatSchools District
  #
  # --
  # TODO: add method to grab schools using +GreatSchools::School#nearby+ with
  # the +address+, +city+, +state+, and +zip_code+ options (parsing address).
  # Filter results to schools with a matching district name.
  # ++
  class District < Model
    attr_accessor :name, :address, :phone, :fax, :website
    attr_accessor :nces_code, :district_rating, :grade_range, :total_schools
    attr_accessor :elementary_schools, :middle_schools, :high_schools
    attr_accessor :public_schools, :charter_schools

    class << self # Class methods
      # Returns a list of school districts in a city.
      #
      # ==== Attributes
      #
      # * +state+ - Two letter state abbreviation
      # * +city+  - Name of city
      def browse(state, city)
        response = GreatSchools::API.get("districts/#{state.upcase}/#{parameterize(city)}")

        Array.wrap(response).map { |district| new(district) }
      end
    end
  end
end
