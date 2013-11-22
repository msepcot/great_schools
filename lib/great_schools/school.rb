module GreatSchools #:nodoc:
  class School < Model
    attr_accessor :id, :name, :type, :grade_range, :enrollment, :district_id, :district, :district_nces_id, :nces_id
    attr_accessor :city, :state, :address, :phone, :fax, :website, :latitude, :longitude
    attr_accessor :overview_link, :ratings_link, :reviews_link, :parent_reviews, :parent_rating

    alias_method :gs_id=, :id=
    alias_method :lat=, :latitude=
    alias_method :lon=, :longitude=

    class << self # Class methods
      # = Browse Schools
      #
      # Returns a list of schools in a city.
      #
      # state (required)  - Two letter state abbreviation
      # city (required)   - Name of city, with spaces replaced with hyphens. If the city name has hyphens, replace those with underscores.
      # school_type       - 'public', 'charter', 'private', combos: 'charter-private', 'public-private', 'public-private-charter'
      # level             - 'elementary-schools', 'middle-schools', 'high-schools'
      # sort              - 'name', 'gs_rating', 'parent_rating'
      # limit             - Maximum number of schools to return. This defaults to 200. To get all results, use -1.
      def browse(state, city, options = {}) # school_types = [], level = nil, sort = :name, limit = 200)
        # TODO validate options
        school_types  = Array.wrap(options.delete(:school_type)).join('-')
        level         = options.delete(:level)

        sort  = options.delete(:sort) || :name
        limit = options.delete(:limit) || 200

        url = "schools/#{state.upcase}/#{parameterize(city)}"
        url << "/#{school_types}" if school_types.present?
        url << "/#{level}" if level.present?

        response = GreatSchools::API.get(url, sort: sort, limit: limit)

        Array.wrap(response).map {|school| new(school) }
      end

      # = Nearby Schools
      #
      # Returns a list of schools closest to the center of a city, ZIP Code or address.
      #
      # state (required) - 2 letter state abbreviation
      # zip - 5 digit zip code
      # city - URL-encoded city name
      # address - URL-encoded address
      # lat - latitude
      # lon - longitude
      # schoolType - Type of school you wish to appear in the list
      # levelCode - Level of school you wish to appear in the list
      # minimumSchools - Minimum # of schools to return. When provided, if the initial query field yields fewer schools than this value, the radius will be increased in 5 mile increments to a maximum of 50 miles or until the result set has enough schools to meet this value. Maximum value is 200. This value must be less than the limit or else it is ignored.
      # radius - Miles radius to confine search to. default: 5 maximum: 50
      # limit - Maximum number of schools to return. This defaults to 200.
      def nearby(state, options = {})
        # schools/nearby?key=[yourAPIKey]&address=160+Spear+St&city=San+Francisco&state=CA&zip=94105&schoolType=public-charter&levelCode=elementary-schools&minimumSchools=50&radius=10&limit=100
        # schools/nearby?key=[yourAPIKey]&city=San+Francisco&state=CA
        # schools/nearby?key=[yourAPIKey]&state=CA&zip=94105
        # schools/nearby?key=[yourAPIKey]&state=CA&lat=37.758862&lon=-122.411406
        # SAMPLE schools/nearby?key=[yourAPIKey]&state=CA&zip=94105&limit=2

        # TODO validate options
        # TODO create a mapping function
        options[:state]           = state
        options[:lat]             = options.delete(:latitude)
        options[:lon]             = options.delete(:longitude)
        options[:schoolType]      = options.delete(:school_type).try(:join, '-')
        options[:levelCode]       = options.delete(:level)
        options[:minimumSchools]  = options.delete(:minimum_schools)

        keys = [:state, :zip, :city, :address, :lat, :lon, :schoolType, :levelCode, :minimumSchools, :radius, :limit]
        options.keep_if {|key, value| keys.include?(key) && value.present? }

        response = GreatSchools::API.get('schools/nearby', options)

        Array.wrap(response).map {|school| new(school) }
      end

      # = School Profile
      #
      # Returns a profile data for a specific school.
      #
      def profile(state, id)
        response = GreatSchools::API.get("schools/#{state.upcase}/#{id}")

        new(response)
      end

      # = School Search
      #
      # Returns a list of schools based on a search string.
      #
      # state (required) - State to search in
      # q (required) - Search query string. The query string must be properly URL-encoded.
      # levelCode - Level of school you wish to appear in the list
      # sort - This call by default sorts the results by relevance. If you'd prefer the results in alphabetical order, then use this parameter with a value of "alpha".
      # limit - Maximum number of schools to return. This defaults to 200 and must be at least 1.
      def search(state, query, options = {})
        # TODO validate options

        options[:levelCode] = options.delete(:level)
        options[:limit]   ||= 200
        options[:q]         = query
        options[:state]     = state

        keys = [:state, :q, :levelCode, :sort, :limit]
        options.keep_if {|key, value| keys.include?(key) && value.present? }

        response = GreatSchools::API.get('search/schools', options)

        Array.wrap(response).map {|school| new(school) }
      end
    end

    # = School Census Data
    #
    # Returns census and profile data for a school.
    # * state - Two letter state abbreviation
    # * id    - Numeric id of school. This gsID is included in other listing requests like Browse Schools and Nearby Schools
    def census
      GreatSchools::Census.for_school(state, id)
    end

    def parent_reviews=(params)
      @parent_reviews = []

      params = params['review'] if params.is_a?(Hash) && params.key?('review')

      Array.wrap(params).each do |hash|
        @parent_reviews << GreatSchools::Review.new(hash)
      end

      @parent_reviews
    end

    # = School Reviews
    #
    # Returns a list of the most recent reviews for a school or for any schools in a city.
    # * state - Two letter state abbreviation
    # * id    - Numeric id of school. This gsID is included in other listing requests like Browse Schools and Nearby Schools
    # * limit - Maximum number of reviews to return. This defaults to 5.
    def reviews(limit = 5)
      GreatSchools::Review.for_school(state, id, limit)
    end

    # = School Test Scores
    #
    # Returns test and rank data for a specific school.
    # * state - Two letter state abbreviation
    # * id    - Numeric id of school. This gsID is included in other listing requests like Browse Schools and Nearby Schools
    def scores
      GreatSchools::Score.for_school(state, id)
    end
  end
end
