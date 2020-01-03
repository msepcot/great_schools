require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::School do
  describe '#browse' do
    it 'should populate school models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'browse_schools.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/schools/CA/Truckee?limit=2&key=0123456789ABCDEF', body: xml)

      schools = GreatSchools::School.browse('CA', 'Truckee', limit: 2)

      expect(schools.size).to eql(2)
      expect(schools[0].name).to eql('Alder Creek Middle School')
      expect(schools[1].name).to eql('Cold Stream Alternative School')

      school = schools.first
      expect(school.id).to eql('13978')
      expect(school.name).to eql('Alder Creek Middle School')
      expect(school.type).to eql('public')
      expect(school.grade_range).to eql('6-8')
      expect(school.enrollment).to eql('598')
      expect(school.rating).to eql('8')
      expect(school.parent_rating).to eql('4')
      expect(school.city).to eql('Truckee')
      expect(school.state).to eql('CA')
      expect(school.district_id).to eql('509')
      expect(school.district).to eql('Tahoe-Truckee Joint Unified School District')
      expect(school.district_nces_id).to eql('0638770')
      expect(school.address).to eql('10931 Alder Dr., Truckee, CA  96161')
      expect(school.phone).to eql('(530) 582-2750')
      expect(school.fax).to eql('(530) 582-7640')
      expect(school.website).to eql('http://www.ttusd.org')
      expect(school.nces_id).to eql('063877011005')
      expect(school.latitude).to eql('39.3454')
      expect(school.longitude).to eql('-120.1735')
      expect(school.overview_link).to eql('http://www.greatschools.org/modperl/browse_school/ca/13978?s_cid=gsapi')
      expect(school.ratings_link).to eql('http://www.greatschools.org/school/rating.page?state=CA&id=13978&s_cid=gsapi')
      expect(school.reviews_link).to eql('http://www.greatschools.org/school/parentReviews.page?state=CA&id=13978&s_cid=gsapi')
      expect(school.school_stats_link).to eql('http://www.greatschools.org/cgi-bin/CA/otherprivate/13978')
    end

    it 'should return an empty array if the server response with no data (404)' do
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/schools/AS/Pago-Pago?limit=2&key=0123456789ABCDEF', body: nil, status: ['404', 'Not Found'])

      schools = GreatSchools::School.browse('AS', 'Pago Pago', limit: 2)
      expect(schools.size).to eql(0)
    end
  end

  describe '#nearby' do
    it 'should populate school models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'nearby_schools.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/schools/nearby?state=CA&zip=94105&limit=2&key=0123456789ABCDEF', body: xml)

      schools = GreatSchools::School.nearby('CA', zip_code: 94105, limit: 2)

      expect(schools.size).to eql(2)
      expect(schools[0].name).to eql('Youth Chance High School')
      expect(schools[1].name).to eql('Notre Dame des Victoires School')

      school = schools.first
      expect(school.id).to eql('11536')
      expect(school.name).to eql('Youth Chance High School')
      expect(school.type).to eql('private')
      expect(school.grade_range).to eql('10-12')
      expect(school.enrollment).to eql('25')
      expect(school.city).to eql('San Francisco')
      expect(school.state).to eql('CA')
      expect(school.address).to eql('169 Steuart Street, San Francisco, CA  94105')
      expect(school.phone).to eql('(415) 615-1337')
      expect(school.nces_id).to eql('A9900759')
      expect(school.latitude).to eql('37.7924')
      expect(school.longitude).to eql('-122.3921')
      expect(school.overview_link).to eql('http://www.greatschools.org/cgi-bin/ca/private/11536?s_cid=gsapi')
      expect(school.ratings_link).to eql('http://www.greatschools.org/school/rating.page?state=CA&id=11536&s_cid=gsapi')
      expect(school.reviews_link).to eql('http://www.greatschools.org/school/parentReviews.page?state=CA&id=11536&s_cid=gsapi')
    end

    it 'should handle no results coming back from the web service' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'nearby_schools_empty.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/schools/nearby?state=CA&zip=00000&limit=2&key=0123456789ABCDEF', body: xml)

      schools = GreatSchools::School.nearby('CA', zip_code: '00000', limit: 2)

      expect(schools.size).to eql(0)
    end
  end

  describe '#profile' do
    it 'should populate school models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_profile.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/schools/CA/1?key=0123456789ABCDEF', body: xml)

      school = GreatSchools::School.profile('CA', 1)

      expect(school.id).to eql('1')
      expect(school.name).to eql('Alameda High School')
      expect(school.type).to eql('public')
      expect(school.grade_range).to eql('9-12')
      expect(school.enrollment).to eql('1938')
      expect(school.city).to eql('Alameda')
      expect(school.state).to eql('CA')
      expect(school.district_id).to eql('1')
      expect(school.district).to eql('Alameda City Unified School District')
      expect(school.district_nces_id).to eql('0601770')
      expect(school.address).to eql('2201 Encinal Ave., Alameda, CA  94501')
      expect(school.phone).to eql('(510) 337-7022')
      expect(school.fax).to eql('(510) 521-4740')
      expect(school.website).to eql('http://ahs.alameda.k12.ca.us/')
      expect(school.nces_id).to eql('060177000041')
      expect(school.latitude).to eql('37.764267')
      expect(school.longitude).to eql('-122.24818')
      expect(school.overview_link).to eql('http://www.greatschools.org/modperl/browse_school/ca/1?s_cid=gsapi')
      expect(school.ratings_link).to eql('http://www.greatschools.org/school/rating.page?state=CA&id=1&s_cid=gsapi')
      expect(school.reviews_link).to eql('http://www.greatschools.org/school/parentReviews.page?state=CA&id=1&s_cid=gsapi')

      school.parent_reviews.each do |review|
        expect(review).to be_a(GreatSchools::Review)
      end
    end
  end

  describe '#search' do
    it 'should populate school models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_search.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/search/schools?limit=2&q=Alameda%20Christian&state=CA&key=0123456789ABCDEF', body: xml)

      schools = GreatSchools::School.search('CA', 'Alameda Christian', limit: 2)

      expect(schools.size).to eql(2)
      expect(schools[0].name).to eql('Alameda Christian School')
      expect(schools[1].name).to eql('Chinese Christian Schools-Alameda')

      school = schools.first
      expect(school.id).to eql('8485')
      expect(school.name).to eql('Alameda Christian School')
      expect(school.type).to eql('private')
      expect(school.grade_range).to eql('K-8')
      expect(school.enrollment).to eql('52')
      expect(school.parent_rating).to eql('5')
      expect(school.city).to eql('Alameda')
      expect(school.state).to eql('CA')
      expect(school.address).to eql('2226 Pacific Ave, Alameda, CA 94501')
      expect(school.phone).to eql('(510) 523-1000')
      expect(school.nces_id).to eql('00079445')
      expect(school.latitude).to eql('37.768623')
      expect(school.longitude).to eql('-122.243965')
      expect(school.overview_link).to eql('http://www.greatschools.org/cgi-bin/ca/private/8485?s_cid=gsapi')
      expect(school.ratings_link).to eql('http://www.greatschools.org/school/rating.page?state=CA&id=8485&s_cid=gsapi')
      expect(school.reviews_link).to eql('http://www.greatschools.org/school/parentReviews.page?state=CA&id=8485&s_cid=gsapi')
    end
  end

  let(:school) { GreatSchools::School.new(state: 'CA', gs_id: 1) }

  describe '.census' do
    it 'should make a GreatSchools::Census#for_school call using state/gs_id attributes' do
      expect(GreatSchools::Census).to receive(:for_school).with('CA', 1)

      school.census
    end
  end

  describe '.reviews' do
    it 'should make a GreatSchools::Review#for_school call using state/gs_id attributes' do
      expect(GreatSchools::Review).to receive(:for_school).with('CA', 1, {})

      school.reviews
    end
  end

  describe '.score' do
    it 'should make a GreatSchools::Score#for_school call using state/gs_id attributes' do
      expect(GreatSchools::Score).to receive(:for_school).with('CA', 1)

      school.score
    end
  end
end
