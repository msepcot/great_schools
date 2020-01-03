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

      expect(results.size).to eql(2)
      expect(results[0].subject_name).to eql('Writing')
      expect(results[1].subject_name).to eql('Reading')

      result = results.first
      expect(result.grade_name).to eql('10')
      expect(result.score).to eql('81.0')
      expect(result.subject_name).to eql('Writing')
      expect(result.test_id).to eql('AZ00137')
      expect(result.year).to eql('2008')
    end
  end
end
