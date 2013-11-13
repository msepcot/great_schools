require 'great_schools/version'

# # Technical Overview
#
# http://www.greatschools.org/api/docs/main.page

module GreatSchools
  class << self
    DOMAIN = 'http://api.greatschools.org/'

    attr_accessor :api_key

    def get(path, parameters = {})
      parameters.merge!(api_key: api_key)
      # TODO make request - DOMAIN/path?parameters
    end
  end
end
