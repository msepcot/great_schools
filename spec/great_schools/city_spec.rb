require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::Census do
  describe '#nearby' do
    it 'should populate city models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'nearby_cities.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/cities/nearby/CA/Bakersfield?radius=16&key=0123456789ABCDEF', body: xml)

      cities = GreatSchools::City.nearby('CA', 'Bakersfield', radius: 16)

      cities.size.should eql(2)
      cities[0].name.should eql('Lamont')
      cities[1].name.should eql('Arvin')

      city = cities.first
      city.state.should eql('CA')
      city.name.should eql('Lamont')
      city.rating.should eql('3')
      city.total_schools.should eql('5')
      city.elementary_schools.should eql('3')
      city.middle_schools.should eql('2')
      city.high_schools.should eql('1')
      city.public_schools.should eql('5')
      city.charter_schools.should eql('0')
      city.private_schools.should eql('0')
    end
  end

  describe '#overview' do
    it 'should populate a city model from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'city_overview.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/cities/AK/Anchorage?key=0123456789ABCDEF', body: xml)

      city = GreatSchools::City.overview('AK', 'Anchorage')

      city.state.should eql('AK')
      city.name.should eql('Anchorage')
      city.rating.should eql('7')
      city.total_schools.should eql('103')
      city.elementary_schools.should eql('76')
      city.middle_schools.should eql('41')
      city.high_schools.should eql('33')
      city.public_schools.should eql('74')
      city.charter_schools.should eql('6')
      city.private_schools.should eql('23')
    end
  end

  describe '.districts' do
    it 'should make a GreatSchools::District#browse call using the state/city attributes' do
      city = GreatSchools::City.new(state: 'IL', city: 'Chicago')

      GreatSchools::District.should_receive(:browse).with('IL', 'Chicago')

      city.districts
    end
  end

  describe '.reviews' do
    it 'should make a GreatSchools::Review#for_city call using the state/city attributes' do
      city = GreatSchools::City.new(state: 'IL', name: 'Chicago')

      GreatSchools::Review.should_receive(:for_city).with('IL', 'Chicago', {})

      city.reviews
    end
  end
end
