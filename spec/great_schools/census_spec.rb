require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::Census do
  describe '#for_school' do
    it 'should populate a census model from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_census_data.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/school/census/ND/20?key=0123456789ABCDEF', body: xml)

      census = GreatSchools::Census.for_school('ND', 20)
      census.school_name.should eql('Simle Middle School')
      census.address.should eql('1215 N 19th St,  Bismarck, ND  58501')
      census.latitude.should eql('46.8179')
      census.longitude.should eql('-100.7631')
      census.phone.should eql('(701) 221-3570')
      census.type.should eql('public')
      census.district.should eql('Bismarck 1')
      census.enrollment.should eql('851')
      census.free_and_reduced_price_lunch.should eql('23.3843')
      census.student_teacher_ratio.should eql('14.1')

      census.ethnicities.each do |ethnicity|
        ethnicity.should be_a(GreatSchools::Ethnicity)
      end
    end
  end
end
