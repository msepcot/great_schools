module GreatSchools #:nodoc:
  class Test < Model
    attr_accessor :name, :id, :description, :abbreviation, :scale, :level_code, :results

    def results=(params)
      @results = []

      Array.wrap(params).each do |hash|
        @results << GreatSchools::Result.new(hash)
      end

      @results
    end
    alias_method :test_result=, :results=
  end
end
