require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::Test do
  it 'should populate score models from the returned XML, through score' do
    xml = File.read(File.expand_path(
      File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_test_scores.xml')
    ))
    FakeWeb.register_uri(:get, 'https://api.greatschools.org/school/tests/AZ/1?key=0123456789ABCDEF', body: xml)

    score = GreatSchools::Score.for_school('AZ', 1)
    tests = score.tests

    expect(tests.size).to eql(1)

    test = tests.first
    expect(test.name).to eql('Arizona\'s Instrument to Measure Standards')
    expect(test.id).to eql('AZ00137')
    expect(test.abbreviation).to eql('AIMS')
    expect(test.scale).to eql('% meeting or exceeding standards')
    expect(test.level_code).to eql('e,m,h')
    expect(test.description).to eql(<<-TEXT.squish)
      In 2007-2008 Arizona's Instrument to Measure Standards (AIMS) was used to
      test students in reading, writing and mathematics in grades 3 through 8
      and 10, and in science in grades 4, 8 and high school. AIMS is a
      standards-based test, which means that it measures how well students have
      mastered Arizona's learning standards. Students must pass the grade 10
      AIMS in order to graduate. The goal is for all students to meet or exceed
      state standards on the test.
    TEXT

    test.results.each do |result|
      expect(result).to be_a(GreatSchools::Result)
    end
  end
end
