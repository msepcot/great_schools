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
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'

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
  # --
  # TODO: load API access key from a config file (great_schools.yml or something)
  # ++
  class API
    class << self # Class methods
      DOMAIN = 'https://api.greatschools.org'

      # The API access key, must be set before making any requests.
      attr_accessor :key

      # Makes an API request to +path+ with the supplied query +parameters+ (merges
      # in the API access +key+).
      #
      # Returns a +Hash+ or an +Array+ with the encompassing XML container stripped.
      #
      # Raises a +GreatSchools::Error+ if the server response code is not 200.
      #
      # ==== Attributes
      #
      # * +path+        - component path of the URL
      # * +parameters+  - +Hash+ of query string elements
      def get(path, parameters = {})
        parameters.merge!(key: key).keep_if { |_,v| v.present? }

        response = HTTParty.get("#{DOMAIN}/#{path}", query: parameters, format: :xml)

        if response.code.eql?(200)
          parse(response.values.first) # strip the container element before parsing
        elsif response.body.blank?
          nil # no error to parse, return nothing
        else
          raise GreatSchools::Error.new(response)
        end
      end

    private

      # Returns a +Hash+ of a single element, or an +Array+ of elements without
      # the container hash.
      def parse(hash)
        if hash && hash.keys.size.eql?(1) # we have an array of elements
          hash.values.first # strip the container and return the array
        else # we have one element, return the hash
          hash
        end
      end
    end
  end
end
