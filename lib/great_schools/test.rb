module GreatSchools #:nodoc:
  class Test < Model
    attr_accessor :name, :id, :description, :abbreviation, :scale, :level_code, :test_results

    def test_results=(params)
      @test_results = []

      Array.wrap(params).each do |hash|
        @test_results << GreatSchools::Result.new(hash)
      end

      @test_results
    end
    alias_method :test_result=, :test_results=
  end
end
