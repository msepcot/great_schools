require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::Test do
  it 'should populate score models from the returned XML, through score' do
    xml = File.read(File.expand_path(
      File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_test_scores.xml')
    ))
    FakeWeb.register_uri(:get, 'http://api.greatschools.org/school/tests/AZ/1?key=0123456789ABCDEF', body: xml)

    score = GreatSchools::Score.for_school('AZ', 1)
    tests = score.tests

    tests.size.should eql(1)

    test = tests.first
    test.name.should eql('Arizona\'s Instrument to Measure Standards')
    test.id.should eql('AZ00137')
    test.abbreviation.should eql('AIMS')
    test.scale.should eql('% meeting or exceeding standards')
    test.level_code.should eql('e,m,h')
    test.description.should eql(<<-TEXT.squish)
      In 2007-2008 Arizona's Instrument to Measure Standards (AIMS) was used to
      test students in reading, writing and mathematics in grades 3 through 8
      and 10, and in science in grades 4, 8 and high school. AIMS is a
      standards-based test, which means that it measures how well students have
      mastered Arizona's learning standards. Students must pass the grade 10
      AIMS in order to graduate. The goal is for all students to meet or exceed
      state standards on the test.
    TEXT

    test.results.each do |result|
      result.should be_a(GreatSchools::Result)
    end
  end
end
