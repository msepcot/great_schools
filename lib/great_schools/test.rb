# # Test
#
# * name
# * id
# * description
# * abbreviation
# * scale
# * levelCode
# * testResult (multiple)
module GreatSchools
  class Test < Model
    attr_accessor :name, :id, :description, :abbreviation, :scale, :level, :results
  end
end
