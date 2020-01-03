require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::Score do
  describe '#for_school' do
    it 'should populate score models from the returned XML, through score' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_test_scores.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/school/tests/AZ/1?key=0123456789ABCDEF', body: xml)

      score = GreatSchools::Score.for_school('AZ', 1)
      rank = score.rank

      expect(rank.name).to eql('AZ GS Rating')
      expect(rank.scale).to eql('1-10')
      expect(rank.year).to eql('2008')
      expect(rank.score).to eql('9.0')
      expect(rank.description).to eql(<<-TEXT.squish)
        GreatSchools Ratings for Arizona are based on the 2007-2008 Arizona's
        Instrument to Measure Standards (AIMS) reading, writing and math results.
        GreatSchools compared the test results for each grade and subject across
        all Arizona schools and divided them into 1 through 10 ratings (10 is
        the best). Please note, private schools are not required to release test
        results, so ratings are available only for public schools. GreatSchools
        Ratings cannot be compared across states, because of differences in the
        states' standardized testing programs. Keep in mind that when comparing
        schools using GreatSchools Ratings it's important to factor in other
        information, including the quality of each school's teachers, the school
        culture, special programs, etc.
      TEXT
    end
  end
end
