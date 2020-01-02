require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::Census do
  describe '#for_school' do
    it 'should populate a census model from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_census_data.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/school/census/ND/20?key=0123456789ABCDEF', body: xml)

      census = GreatSchools::Census.for_school('ND', 20)
      expect(census.school_name).to eq('Simle Middle School')
      expect(census.address).to eq('1215 N 19th St,  Bismarck, ND  58501')
      expect(census.latitude).to eq('46.8179')
      expect(census.longitude).to eq('-100.7631')
      expect(census.phone).to eq('(701) 221-3570')
      expect(census.type).to eq('public')
      expect(census.district).to eq('Bismarck 1')
      expect(census.enrollment).to eq('851')
      expect(census.free_and_reduced_price_lunch).to eq('23.3843')
      expect(census.student_teacher_ratio).to eq('14.1')

      census.ethnicities.each do |ethnicity|
        expect(ethnicity).to be_a(GreatSchools::Ethnicity)
      end
    end
  end
end
