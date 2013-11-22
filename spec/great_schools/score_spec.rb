require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::Score do
  describe '#for_school' do
    it 'should populate score models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_test_scores.xml')
      ))
      FakeWeb.register_uri(:get, 'http://api.greatschools.org/school/tests/AZ/1?key=0123456789ABCDEF', body: xml)

      score = GreatSchools::Score.for_school('AZ', 1)

      score.school_name.should eql('Flagstaff High School')
      score.rank.should be_a(GreatSchools::Rank)
      score.tests.each do |test|
        test.should be_a(GreatSchools::Test)
      end
    end
  end
end
