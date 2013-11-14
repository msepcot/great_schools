require 'great_schools/model'
require 'great_schools/city'
require 'great_schools/district'
require 'great_schools/school'
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
