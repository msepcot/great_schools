# # Census Data
#
# * schoolName
# * address
# * latitude
# * longitude
# * phone
# * type
# * district
# * enrollment
# * freeAndReducedPriceLunch
# * studentTeacherRatio
# * ethnicities
module GreatSchools
  class Census
    attr_accessor :school_name, :address, :latitude, :longitude, :phone, :type, :district, :enrollment
    attr_accessor :free_and_reduced_price_lunch, :student_teacher_ratio, :ethnicities
  end
end
