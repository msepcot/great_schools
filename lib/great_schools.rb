require 'great_schools/error'
require 'great_schools/model'

require 'great_schools/census'
require 'great_schools/city'
require 'great_schools/district'
require 'great_schools/ethnicity'
require 'great_schools/rank'
require 'great_schools/result'
require 'great_schools/review'
require 'great_schools/school'
require 'great_schools/score'
require 'great_schools/test'

require 'great_schools/version'

require 'active_support'
require 'active_support/core_ext/array/wrap'

require 'httparty'

# = GreatSchools
#
# GreatSchools profiles more than 90,000 public and 30,000 private schools in
# the United States. With hundreds of thousands of ratings and Parent Reviews
# about schools nationwide, we provide the most comprehensive data about
# elementary, middle and high schools.
module GreatSchools
  # The GreatSchools API allows you to add valuable information to your
  # application, including:
  #
  # * Schools in a city
  # * Schools near an address
  # * Data about specific schools, including school directory information,
  #   grade levels, enrollment, test scores, ratings and reviews and more.
  #
  # Before you can start using the GreatSchool API, you must register and
  # request an access key at: http://www.greatschools.org/api/registration.page
  class API
    class << self # Class methods
      DOMAIN = 'http://api.greatschools.org'

      attr_accessor :key

      def get(path, parameters = {})
        parameters.merge!(key: key)

        response = HTTParty.get("#{DOMAIN}/#{path}", query: parameters, format: :xml)

        if response.code.eql?(200)
          parse(response.values.first) # strip the container element before parsing
        else
          raise GreatSchools::Error.new(response)
        end
      end

    private

      def parse(hash)
        if hash.keys.size.eql?(1) # we have an array of elements
          hash.values.first # strip the container and return the array
        else # we have one element, return the hash
          hash
        end
      end
    end
  end
end
