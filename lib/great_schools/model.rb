require 'cgi'

module GreatSchools # :nodoc:
  # = GreatSchools Base Model
  class Model
    class << self # Class methods
    protected
      # Makes a URL slug from the string.
      #
      # Replaces dashes with underscores, spaces with dashes, and URL encodes
      # any special characters.
      #
      # ==== Examples
      #
      #   parameterize('San Francisco')       # => 'San-Francisco'
      #   parameterize('Cardiff-By-The-Sea')  # => 'Cardiff_By_The_Sea'
      def parameterize(string)
        CGI.escape(string.gsub('-', '_').gsub(' ', '-'))
      end
    end

    # Base initializer, map camelCased XML attributes from the GreatSchools API
    # response to the appropriately underscored attribute setters.
    def initialize(attributes = {})
      attributes.each do |key, value|
        key = underscore(key)
        send("#{key}=", value) if respond_to?("#{key}=")
      end
    end

  protected

    # Makes an underscored, lowercase form from the expression in the string.
    #
    # ==== Examples
    #
    #   underscore('myACRONYMString') # => 'my_acronym_string'
    def underscore(word)
      word = word.to_s.dup # unfreeze any frozen strings
      word.gsub!(/([a-z])([A-Z])/,'\1_\2')          # myACRONYMString   => my_ACRONYMString
      word.gsub!(/([A-Z]+)(?=[A-Z][a-z])/, '\1_\2') # my_ACRONYMString  => my_ACRONYM_String
      word.downcase                                 # my_ACRONYM_String => my_acronym_string
    end
  end
end
