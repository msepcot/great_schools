require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::District do
  describe '#browse' do
    it 'should populate district models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'browse_districts.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/districts/CA/San-Francisco?key=0123456789ABCDEF', body: xml)

      districts = GreatSchools::District.browse('CA', 'San Francisco')

      expect(districts.size).to eql(2)
      expect(districts[0].name).to eql('San Francisco Unified School District')
      expect(districts[1].name).to eql('San Francisco County Office of Education')

      district = districts.first
      expect(district.name).to eql('San Francisco Unified School District')
      expect(district.nces_code).to eql('0634410')
      expect(district.district_rating).to eql('6')
      expect(district.address).to eql('555 Franklin St., San Francisco, CA 94102')
      expect(district.phone).to eql('(415) 241-6000')
      expect(district.fax).to eql('(415) 241-6012')
      expect(district.website).to eql('http://www.sfusd.k12.ca.us')
      expect(district.grade_range).to eql('K-12 & ungraded')
      expect(district.total_schools).to eql('121')
      expect(district.elementary_schools).to eql('84')
      expect(district.middle_schools).to eql('36')
      expect(district.high_schools).to eql('34')
      expect(district.public_schools).to eql('113')
      expect(district.charter_schools).to eql('8')
    end
  end
end
