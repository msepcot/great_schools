require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::Census do
  describe '#nearby' do
    it 'should populate city models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'nearby_cities.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/cities/nearby/CA/Bakersfield?radius=16&key=0123456789ABCDEF', body: xml)

      cities = GreatSchools::City.nearby('CA', 'Bakersfield', radius: 16)

      expect(cities.size).to eq(2)
      expect(cities[0].name).to eq('Lamont')
      expect(cities[1].name).to eq('Arvin')

      city = cities.first
      expect(city.state).to eq('CA')
      expect(city.name).to eq('Lamont')
      expect(city.rating).to eq('3')
      expect(city.total_schools).to eq('5')
      expect(city.elementary_schools).to eq('3')
      expect(city.middle_schools).to eq('2')
      expect(city.high_schools).to eq('1')
      expect(city.public_schools).to eq('5')
      expect(city.charter_schools).to eq('0')
      expect(city.private_schools).to eq('0')
    end
  end

  describe '#overview' do
    it 'should populate a city model from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'city_overview.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/cities/AK/Anchorage?key=0123456789ABCDEF', body: xml)

      city = GreatSchools::City.overview('AK', 'Anchorage')

      expect(city.state).to eq('AK')
      expect(city.name).to eq('Anchorage')
      expect(city.rating).to eq('7')
      expect(city.total_schools).to eq('103')
      expect(city.elementary_schools).to eq('76')
      expect(city.middle_schools).to eq('41')
      expect(city.high_schools).to eq('33')
      expect(city.public_schools).to eq('74')
      expect(city.charter_schools).to eq('6')
      expect(city.private_schools).to eq('23')
    end
  end

  describe '.districts' do
    it 'should make a GreatSchools::District#browse call using the state/city attributes' do
      city = GreatSchools::City.new(state: 'IL', city: 'Chicago')

      expect(GreatSchools::District).to receive(:browse).with('IL', 'Chicago')

      city.districts
    end
  end

  describe '.reviews' do
    it 'should make a GreatSchools::Review#for_city call using the state/city attributes' do
      city = GreatSchools::City.new(state: 'IL', name: 'Chicago')

      expect(GreatSchools::Review).to receive(:for_city).with('IL', 'Chicago', {})

      city.reviews
    end
  end
end
