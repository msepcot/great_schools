module GreatSchools #:nodoc:
  class School < Model
    attr_accessor :gs_id, :name, :type, :grade_range, :enrollment, :district_id, :district, :district_nces_id, :nces_id
    attr_accessor :city, :state, :address, :phone, :fax, :website, :latitude, :longitude
    attr_accessor :overview_link, :ratings_link, :reviews_link, :parent_reviews

    class << self # Class methods
      # = Browse Schools
      #
      # Returns a list of schools in a city.
      #
      # state       - Two letter state abbreviation
      # city        - Name of city, with spaces replaced with hyphens. If the city name has hyphens, replace those with underscores.
      # school_type - 'public', 'charter', 'private', combos: 'charter-private', 'public-private', 'public-private-charter'
      # level       - 'elementary-schools', 'middle-schools', 'high-schools'
      # sort        - 'name', 'gs_rating', 'parent_rating'
      # limit       - Maximum number of schools to return. This defaults to 200. To get all results, use -1.
      def browse(state, city, school_types = [], level = nil, sort = :name, limit = 200)
        # schools/CA/Alameda?key=[yourAPIkey]
        # schools/CA/Alameda?key=[yourAPIkey]&limit=-1
        # schools/CA/San-Francisco/private/middle-schools?key=[yourAPIkey]&sort=parent_rating&limit=5
        # SAMPLE schools/CA/Truckee?key=[yourAPIkey]&limit=2

        # TODO validate parameters
        url = "schools/#{state.upcase}/#{parameterize(city)}/#{[*school_types].join('-')}/#{level}".gsub('//', '/')

        response = GreatSchools::API.get(url, sort: sort, limit: limit)

        Array.wrap(response).map {|review| new(review) }
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

        keys = [:state, :zip, :city, :address, :lat, :lon, :schoolType, :levelCode, :minimumSchools, :radius, :limit]
        options.keep_if {|key,_| keys.include?(key) }

        response = GreatSchools::API.get('schools/nearby', options)

        Array.wrap(response).map {|review| new(review) }
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
      def search(state, query, level = nil, sort = nil, limit = 200)
        # search/schools?key=[yourAPIKey]&state=CA&q=Alameda
        # search/schools?key=[yourAPIKey]&state=CA&q=Alameda&sort=alpha&levelCode=elementary-schools&limit=10
        # SAMPLE search/schools?key=[yourAPIKey]&state=CA&q=Alameda+Christian&limit=2

        response = GreatSchools::API.get("search/schools", state: state, q: query, levelCode: level, sort: sort, limit: limit)

        Array.wrap(response).map {|review| new(review) }
      end
    end

    # = School Reviews
    #
    # Returns a list of the most recent reviews for a school or for any schools in a city.
    # * state - Two letter state abbreviation
    # * id    - Numeric id of school. This gsID is included in other listing requests like Browse Schools and Nearby Schools
    # * limit - Maximum number of reviews to return. This defaults to 5.
    def reviews(limit = 5)
      GreatSchools::Review.for_school(state, gs_id, limit)
    end

    # = School Test Scores
    #
    # Returns test and rank data for a specific school.
    # * state - Two letter state abbreviation
    # * id    - Numeric id of school. This gsID is included in other listing requests like Browse Schools and Nearby Schools
    def scores
      GreatSchools::Score.for_school(state, gs_id)
    end

    # = School Census Data
    #
    # Returns census and profile data for a school.
    # * state - Two letter state abbreviation
    # * id    - Numeric id of school. This gsID is included in other listing requests like Browse Schools and Nearby Schools
    def census
      GreatSchools::Census.for_school(state, gs_id)
    end
  end
end
