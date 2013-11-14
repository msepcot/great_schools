# # Review
#
# * schoolName
# * schoolAddress
# * reviewLink
# * rating
# * submitter
# * postedDate
# * comments
module GreatSchools
  class Review
    attr_accessor :school_name, :school_address
    attr_accessor :review_link, :rating, :submitter, :posted_date, :comments
  end
end
