module GreatSchools # :nodoc:
  # = GreatSchools Test
  class Test < Model
    attr_accessor :name, :id, :description, :abbreviation, :scale, :level_code, :results

    # Set an array of +GreatSchools::Result+.
    #
    # ==== Attributes
    #
    # * +params+ - a +Hash+ or +Array+ of +GreatSchools::Result+ attributes.
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
