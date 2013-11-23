module GreatSchools # :nodoc:
  # = School Census and Profile Data
  #
  # While you can pull census data for a school manually, I'd recommend going
  # through the school model and letting it make the call for you:
  #
  #   schools = GreatSchools::School.browse('CA', 'San Mateo')
  #   school = schools.first
  #   school.census # equivalent to: GreatSchools::Census.for_school(school.state, school.id)
  class Census < Model
    # --
    # NOTE: these are all +GreatSchool::School+ attributes, should we build a
    # school model instead of attaching these attributes?
    # ++
    attr_accessor :school_name, :address, :latitude, :longitude, :phone, :type, :district, :enrollment

    attr_accessor :free_and_reduced_price_lunch, :student_teacher_ratio, :ethnicities

    class << self # Class methods
      # Returns census and profile data for a school.
      #
      # ==== Attributes
      #
      # * +state+ - Two letter state abbreviation
      # * +id+    - Numeric id of a school. This GreatSchools ID is included in
      #             other listing requests like +GreatSchools::School#browse+
      #             and +GreatSchools::School#nearby+
      def for_school(state, id)
        response = GreatSchools::API.get("school/census/#{state.upcase}/#{id}")

        new(response)
      end
    end

    # Set an array of +GreatSchools::Ethnicity+.
    #
    # ==== Attributes
    #
    # * +params+ - a +Hash+ or +Array+ of +GreatSchools::Ethnicity+ attributes.
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
