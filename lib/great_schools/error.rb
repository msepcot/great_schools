module GreatSchools #:nodoc:
  class Error < StandardError
    attr_reader :call, :date, :error_code

    alias_method :fault_string, :message

    def initialize(response)
      super(response['error']['faultString'])

      @call = response['error']['call']
      @date = response['error']['date']
      @error_code = response['error']['errorCode']
    end

    def inspect #:nodoc:
      "#<#{self.class} error_code: #{error_code}, fault_string: \"#{message}\", call: \"#{call}\", date: \"#{date}\">"
    end
  end
end
