require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::District do
  describe '#browse' do
    it 'should populate district models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'browse_districts.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/districts/CA/San-Francisco?key=0123456789ABCDEF', body: xml)

      districts = GreatSchools::District.browse('CA', 'San Francisco')

      districts.size.should eql(2)
      districts[0].name.should eql('San Francisco Unified School District')
      districts[1].name.should eql('San Francisco County Office of Education')

      district = districts.first
      district.name.should eql('San Francisco Unified School District')
      district.nces_code.should eql('0634410')
      district.district_rating.should eql('6')
      district.address.should eql('555 Franklin St., San Francisco, CA 94102')
      district.phone.should eql('(415) 241-6000')
      district.fax.should eql('(415) 241-6012')
      district.website.should eql('http://www.sfusd.k12.ca.us')
      district.grade_range.should eql('K-12 & ungraded')
      district.total_schools.should eql('121')
      district.elementary_schools.should eql('84')
      district.middle_schools.should eql('36')
      district.high_schools.should eql('34')
      district.public_schools.should eql('113')
      district.charter_schools.should eql('8')
    end
  end
end
