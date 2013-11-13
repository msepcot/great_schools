# # School
#
# * gsId
# * name
# * type
# * gradeRange
# * enrollment
# * city
# * state
# * districtId
# * district
# * districtNCESId
# * address
# * phone
# * fax
# * website
# * ncesId
# * lat
# * lon
# * overviewLink
# * ratingsLink
# * reviewsLink
# * parentReviews


module GreatSchools
  class School

    # ### Browse Schools
    #
    # Returns a list of schools in a city.
    #
    # ### Nearby Schools
    #
    # Returns a list of schools closest to the center of a city, ZIP Code or address.
    #
    # ### School Profile
    #
    # Returns a profile data for a specific school.
    #
    # ### School Search
    #
    # Returns a list of schools based on a search string.
    #
    class << self
      # state       - Two letter state abbreviation
      # city        - Name of city, with spaces replaced with hyphens. If the city name has hyphens, replace those with underscores.
      # school_type - 'public', 'charter', 'private', combos: 'charter-private', 'public-private', 'public-private-charter'
      # level       - 'elementary-schools', 'middle-schools', 'high-schools'
      # sort        - 'name', 'gs_rating', 'parent_rating'
      # limit       - Maximum number of schools to return. This defaults to 200. To get all results, use -1.
      def browse(state, city, school_type, level, sort = :name, limit = 200)
        # schools/CA/Alameda?key=[yourAPIkey]
        # schools/CA/Alameda?key=[yourAPIkey]&limit=-1
        # schools/CA/San-Francisco/private/middle-schools?key=[yourAPIkey]&sort=parent_rating&limit=5
        # SAMPLE schools/CA/Truckee?key=[yourAPIkey]&limit=2
      end

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
      def nearby
        # schools/nearby?key=[yourAPIKey]&address=160+Spear+St&city=San+Francisco&state=CA&zip=94105&schoolType=public-charter&levelCode=elementary-schools&minimumSchools=50&radius=10&limit=100
        # schools/nearby?key=[yourAPIKey]&city=San+Francisco&state=CA
        # schools/nearby?key=[yourAPIKey]&state=CA&zip=94105
        # schools/nearby?key=[yourAPIKey]&state=CA&lat=37.758862&lon=-122.411406
        # SAMPLE schools/nearby?key=[yourAPIKey]&state=CA&zip=94105&limit=2
      end

      def profile(state, id)
        # SAMPLE schools/CA/1?key=[yourkey]
      end

      # state (required) - State to search in
      # q (required) - Search query string. The query string must be properly URL-encoded.
      # levelCode - Level of school you wish to appear in the list
      # sort - This call by default sorts the results by relevance. If you'd prefer the results in alphabetical order, then use this parameter with a value of "alpha".
      # limit - Maximum number of schools to return. This defaults to 200 and must be at least 1.
      def search(state, query, level, sort, limit)
        # search/schools?key=[yourAPIKey]&state=CA&q=Alameda
        # search/schools?key=[yourAPIKey]&state=CA&q=Alameda&sort=alpha&levelCode=elementary-schools&limit=10
        # SAMPLE search/schools?key=[yourAPIKey]&state=CA&q=Alameda+Christian&limit=2
      end
    end

    # ### School Reviews
    #
    # Returns a list of the most recent reviews for a school or for any schools in a city.
    #
    # ### School Test Scores
    #
    # Returns test and rank data for a specific school.
    #
    # ### School Census Data
    #
    # Returns census and profile data for a school.

  end
end
