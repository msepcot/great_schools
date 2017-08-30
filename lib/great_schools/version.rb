module GreatSchools # :nodoc:
  class Version # :nodoc:
    MAJOR = 0 # version when you make incompatible API changes
    MINOR = 2 # version when you add functionality in a backwards-compatible manner
    PATCH = 2 # version when you make backwards-compatible bug fixes

    class << self # Class methods
      # MAJOR.MINOR.PATCH per Semantic Versioning 2.0.0
      def to_s
        "#{MAJOR}.#{MINOR}.#{PATCH}"
      end
    end
  end
end
