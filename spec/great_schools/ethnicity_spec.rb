require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::Ethnicity do
  it 'should populate an ethnicity model from the returned XML, through a census' do
    xml = File.read(File.expand_path(
      File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_census_data.xml')
    ))
    FakeWeb.register_uri(:get, 'https://api.greatschools.org/school/census/ND/20?key=0123456789ABCDEF', body: xml)

    census = GreatSchools::Census.for_school('ND', 20)
    ethnicity = census.ethnicities.first

    expect(ethnicity.name).to eql('White, non-Hispanic')
    expect(ethnicity.value).to eql('91.0693')
    expect(ethnicity.year).to eql('2007')
  end
end
