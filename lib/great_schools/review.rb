# # Review
#
# * schoolName
# * schoolAddress
# * reviewLink
# * rating
# * submitter
# * postedDate
# * comments
module GreatSchools
  class Review < Model
    attr_accessor :school_name, :school_address
    attr_accessor :review_link, :rating, :submitter, :posted_date, :comments

    class << self # Class methods
      # ### School Reviews
      #
      # Returns a list of the most recent reviews for a school or for any schools in a city.
      # * state       - Two letter state abbreviation
      # * city        - Name of city, with spaces replaced with hyphens. If the city name has hyphens, replace those with underscores.
      # * cutoff_age  - Reviews must have been published after this many days ago to be returned. Only valid for the recent reviews in a city call.
      # * limit       - Maximum number of reviews to return. This defaults to 5.
      def for_city(state, city, cutoff_age = nil, limit = 5)
        response = GreatSchools::API.get("reviews/city/#{state.upcase}/#{parameterize(name)}", cutoffAge: cutoff_age, limit: limit)

        parse_response(response)
      end

      # ### School Reviews
      #
      # Returns a list of the most recent reviews for a school or for any schools in a city.
      # * state - Two letter state abbreviation
      # * id    - Numeric id of school. This gsID is included in other listing requests like Browse Schools and Nearby Schools
      # * limit - Maximum number of reviews to return. This defaults to 5.
      def for_school(state, id, limit = 5)
        response = GreatSchools::API.get("reviews/school/#{state.upcase}/#{id}", limit: limit)

        parse_response(response)
      end

    private

      # #<Net::HTTPUnauthorized 401 Unauthorized readbody=true>
      # {"error"=>{"errorCode"=>"3", "faultString"=>"Invalid API key.", "date"=>"2013/11/14", "call"=>"/reviews/city/CA/Foster-City"}}
      def parse_response(response)
        reviews = response.fetch('reviews', {}).fetch('review')
        reviews = [reviews] unless reviews.is_a?(Array)

        reviews.map {|review| Review.new(review) }
      end
    end
  end
end
