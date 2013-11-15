# # Test Result
#
# * gradeName
# * score
# * subjectName
# * testId
# * year
module GreatSchools
  class Result < Model
    attr_accessor :grade_name, :score, :subject_name, :test_id, :year
  end
end
