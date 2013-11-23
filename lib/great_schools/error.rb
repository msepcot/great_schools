module GreatSchools # :nodoc:
  # = GreatSchools Error
  #
  # Encompass any errors sent back by the GreatSchools API.
  #
  # GreatSchools sends back XML to all API requests. The error response looks
  # like:
  #
  #   <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
  #   <error>
  #     <errorCode>3</errorCode>
  #     <faultString>Invalid API key.</faultString>
  #     <date>2013/11/22</date>
  #     <call>/reviews/city/CA/Foster-City</call>
  #   </error>
  #
  # ==== Examples
  #
  # The most common error is trying to request data that your API key does not
  # have access to.
  #
  #   GreatSchools::API.key = 'INVALID_KEY'
  #   GreatSchools::Review.for_city('CA', 'Foster City')
  #   # => #<GreatSchools::Error error_code: "3", fault_string: "Invalid API key.", call: "/reviews/city/CA/Foster-City", date: "2013/11/22">
  class Error < StandardError
    attr_reader :call, :date, :error_code

    alias_method :fault_string, :message

    # Creates a new +GreatSchools::Error+ from a parsed +HTTParty+ response.
    # The +faultString+ is used as the error +message+.
    #
    # ==== Attributes
    #
    # * +response+ - a parsed response object from +HTTParty+
    # --
    # TODO: add error handling - ensure we have a +Hash+, use +fetch+ with defaults
    # ++
    def initialize(response)
      super(response['error']['faultString'])

      @call = response['error']['call']
      @date = response['error']['date']
      @error_code = response['error']['errorCode']
    end

    def inspect # :nodoc:
      "#<#{self.class} error_code: \"#{error_code}\", fault_string: \"#{message}\", call: \"#{call}\", date: \"#{date}\">"
    end
  end
end
