module GreatSchools # :nodoc:
  # = GreatSchools School
  class School < Model
    attr_accessor :id, :name, :type, :grade_range, :enrollment, :district_id, :district, :district_nces_id, :nces_id
    attr_accessor :city, :state, :address, :phone, :fax, :website, :latitude, :longitude
    attr_accessor :overview_link, :ratings_link, :reviews_link, :parent_reviews, :parent_rating

    alias_method :gs_id=, :id=
    alias_method :lat=, :latitude=
    alias_method :lon=, :longitude=

    class << self # Class methods
      # Returns a list of schools in a city.
      #
      # ==== Attributes
      #
      # * +state+ - Two letter state abbreviation
      # * +city+  - Name of city
      #
      # ==== Options
      #
      # * +:school_types+ - Type of school(s) you wish to appear in the list:
      #                     'public', 'charter', and/or 'private'
      # * +:level+        - Level of school you wish to appear in the list:
      #                     'elementary-schools', 'middle-schools', or 'high-schools'
      # * +:sort+         - How to sort the results, either by name (ascending),
      #                     by GreatSchools rating (descending), or by overall
      #                     parent rating (descending). The default sort is name
      #                     (ascending). When sorted by rating, schools without
      #                     a rating will appear last. Options: 'name',
      #                     'gs_rating', or 'parent_rating'
      # * +:limit+        - Maximum number of schools to return. This defaults
      #                     to 200. To get all results, use -1.
      # --
      # TODO: handle validations
      # ++
      def browse(state, city, options = {})
        school_types  = Array.wrap(options.delete(:school_types)).join('-')
        level         = options.delete(:level)

        url = "schools/#{state.upcase}/#{parameterize(city)}"
        url << "/#{school_types}" if school_types.present?
        url << "/#{level}"        if level.present?

        response = GreatSchools::API.get(url, options.slice(:sort, :limit))

        Array.wrap(response).map { |school| new(school) }
      end

      # Returns a list of schools closest to the center of a city, ZIP Code or
      # address.
      #
      # ==== Attributes
      #
      # * +state+ - Two letter state abbreviation
      #
      # ==== Options
      #
      # * +:zip_code+         - 5 digit zip code
      # * +:city+             - Name of city
      # * +:address+          - Address of location
      # * +:latitude+         - Latitude of location
      # * +:longitude+        - Longitude of location
      # * +:school_types+     - Type of school(s) you wish to appear in the list:
      #                         'public', 'charter', and/or 'private'
      # * +:level+            - Level of school you wish to appear in the list:
      #                         'elementary-schools', 'middle-schools', or 'high-schools'
      # * +:minimum_schools+  - Minimum number of schools to return. When provided,
      #                         if the initial query field yields fewer schools than
      #                         this value, the radius will be increased in 5 mile
      #                         increments to a maximum of 50 miles or until the
      #                         result set has enough schools to meet this value.
      #                         Maximum value is 200. This value must be less than
      #                         the limit or else it is ignored.
      # * +:radius+           - Miles radius to confine search to. This default to 5,
      #                         with a maximum of 50.
      # * +:limit+            - Maximum number of schools to return. This defaults to 200.
      # --
      # TODO: handle validations
      # ++
      def nearby(state, options = {})
        options[:lat]             = options.delete(:latitude)
        options[:levelCode]       = options.delete(:level)
        options[:lon]             = options.delete(:longitude)
        options[:minimumSchools]  = options.delete(:minimum_schools)
        options[:schoolType]      = options.delete(:school_types).try(:join, '-')
        options[:state]           = state
        options[:zip]             = options.delete(:zip_code)

        options.slice!(:address, :city, :lat, :levelCode, :limit, :lon, :minimumSchools, :radius, :schoolType, :state, :zip)

        response = GreatSchools::API.get('schools/nearby', options)

        Array.wrap(response).map { |school| new(school) }
      end

      # Returns profile data for a specific school.
      #
      # ==== Attributes
      #
      # * +state+ - Two letter state abbreviation
      # * +id+    - Numeric id of a school. This GreatSchools ID is included in
      #             other listing requests like +GreatSchools::School#browse+
      #             and +GreatSchools::School#nearby+
      def profile(state, id)
        response = GreatSchools::API.get("schools/#{state.upcase}/#{id}")

        new(response)
      end

      # Returns a list of schools based on a search string.
      #
      # ==== Attributes
      #
      # * +state+ - Two letter state abbreviation
      # * +query+ - Search query string
      #
      # ==== Options
      #
      # * +:level+  - Level of school you wish to appear in the list:
      #               'elementary-schools', 'middle-schools', or 'high-schools'
      # * +:sort+   - This call by default sorts the results by relevance. You
      #               can sort the results alphabetically by using 'alpha'.
      # * +:limit+  - Maximum number of schools to return. This defaults to
      #               200 and must be at least 1.
      # --
      # TODO: handle validations
      # ++
      def search(state, query, options = {})
        options[:levelCode] = options.delete(:level)
        options[:q]         = query
        options[:state]     = state
        options.slice!(:state, :q, :levelCode, :sort, :limit)

        response = GreatSchools::API.get('search/schools', options)

        Array.wrap(response).map { |school| new(school) }
      end
    end

    # Returns census and profile data for the school.
    def census
      GreatSchools::Census.for_school(state, id)
    end

    # Set an array of +GreatSchools::Review+.
    #
    # ==== Attributes
    #
    # * +params+ - a +Hash+ or +Array+ of +GreatSchools::Review+ attributes.
    def parent_reviews=(params)
      @parent_reviews = []

      params = params['review'] if params.is_a?(Hash) && params.key?('review')

      Array.wrap(params).each do |hash|
        @parent_reviews << GreatSchools::Review.new(hash)
      end

      @parent_reviews
    end

    # Returns a list of the most recent reviews for the school.
    #
    # ==== Options
    #
    # * +:limit+ - Maximum number of reviews to return. This defaults to 5.
    def reviews(options = {})
      GreatSchools::Review.for_school(state, id, options.slice(:limit))
    end

    # Returns test and rank data for the school.
    def score
      GreatSchools::Score.for_school(state, id)
    end
  end
end
