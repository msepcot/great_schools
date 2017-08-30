require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::Score do
  describe '#for_school' do
    it 'should populate score models from the returned XML, through test (through score)' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_test_scores.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/school/tests/AZ/1?key=0123456789ABCDEF', body: xml)

      score = GreatSchools::Score.for_school('AZ', 1)
      results = score.tests.first.results

      results.size.should eql(2)
      results[0].subject_name.should eql('Writing')
      results[1].subject_name.should eql('Reading')

      result = results.first
      result.grade_name.should eql('10')
      result.score.should eql('81.0')
      result.subject_name.should eql('Writing')
      result.test_id.should eql('AZ00137')
      result.year.should eql('2008')
    end
  end
end
