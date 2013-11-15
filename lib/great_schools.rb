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

require 'httparty'

# = Technical Overview
#
# http://www.greatschools.org/api/docs/main.page

module GreatSchools
  class API
    class << self
      DOMAIN = 'http://api.greatschools.org'

      attr_accessor :key

      def get(path, parameters = {})
        parameters.merge!(key: key)

        HTTParty.get("#{DOMAIN}/#{path}", query: parameters)
      end
    end
  end
end
