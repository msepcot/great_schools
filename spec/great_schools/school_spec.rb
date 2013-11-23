require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::School do
  describe '#browse' do
    it 'should populate school models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'browse_schools.xml')
      ))
      FakeWeb.register_uri(:get, 'http://api.greatschools.org/schools/CA/Truckee?limit=2&key=0123456789ABCDEF', body: xml)

      schools = GreatSchools::School.browse('CA', 'Truckee', limit: 2)

      schools.size.should eql(2)
      schools[0].name.should eql('Alder Creek Middle School')
      schools[1].name.should eql('Cold Stream Alternative School')

      school = schools.first
      school.id.should eql('13978')
      school.name.should eql('Alder Creek Middle School')
      school.type.should eql('public')
      school.grade_range.should eql('6-8')
      school.enrollment.should eql('598')
      school.city.should eql('Truckee')
      school.state.should eql('CA')
      school.district_id.should eql('509')
      school.district.should eql('Tahoe-Truckee Joint Unified School District')
      school.district_nces_id.should eql('0638770')
      school.address.should eql('10931 Alder Dr., Truckee, CA  96161')
      school.phone.should eql('(530) 582-2750')
      school.fax.should eql('(530) 582-7640')
      school.website.should eql('http://www.ttusd.org')
      school.nces_id.should eql('063877011005')
      school.latitude.should eql('39.3454')
      school.longitude.should eql('-120.1735')
      school.overview_link.should eql('http://www.greatschools.org/modperl/browse_school/ca/13978?s_cid=gsapi')
      school.ratings_link.should eql('http://www.greatschools.org/school/rating.page?state=CA&id=13978&s_cid=gsapi')
      school.reviews_link.should eql('http://www.greatschools.org/school/parentReviews.page?state=CA&id=13978&s_cid=gsapi')
    end
  end

  describe '#nearby' do
    it 'should populate school models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'nearby_schools.xml')
      ))
      FakeWeb.register_uri(:get, 'http://api.greatschools.org/schools/nearby?state=CA&zip=94105&limit=2&key=0123456789ABCDEF', body: xml)

      schools = GreatSchools::School.nearby('CA', zip_code: 94105, limit: 2)

      schools.size.should eql(2)
      schools[0].name.should eql('Youth Chance High School')
      schools[1].name.should eql('Notre Dame des Victoires School')

      school = schools.first
      school.id.should eql('11536')
      school.name.should eql('Youth Chance High School')
      school.type.should eql('private')
      school.grade_range.should eql('10-12')
      school.enrollment.should eql('25')
      school.city.should eql('San Francisco')
      school.state.should eql('CA')
      school.address.should eql('169 Steuart Street, San Francisco, CA  94105')
      school.phone.should eql('(415) 615-1337')
      school.nces_id.should eql('A9900759')
      school.latitude.should eql('37.7924')
      school.longitude.should eql('-122.3921')
      school.overview_link.should eql('http://www.greatschools.org/cgi-bin/ca/private/11536?s_cid=gsapi')
      school.ratings_link.should eql('http://www.greatschools.org/school/rating.page?state=CA&id=11536&s_cid=gsapi')
      school.reviews_link.should eql('http://www.greatschools.org/school/parentReviews.page?state=CA&id=11536&s_cid=gsapi')
    end
  end

  describe '#profile' do
    it 'should populate school models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_profile.xml')
      ))
      FakeWeb.register_uri(:get, 'http://api.greatschools.org/schools/CA/1?key=0123456789ABCDEF', body: xml)

      school = GreatSchools::School.profile('CA', 1)

      school.id.should eql('1')
      school.name.should eql('Alameda High School')
      school.type.should eql('public')
      school.grade_range.should eql('9-12')
      school.enrollment.should eql('1938')
      school.city.should eql('Alameda')
      school.state.should eql('CA')
      school.district_id.should eql('1')
      school.district.should eql('Alameda City Unified School District')
      school.district_nces_id.should eql('0601770')
      school.address.should eql('2201 Encinal Ave., Alameda, CA  94501')
      school.phone.should eql('(510) 337-7022')
      school.fax.should eql('(510) 521-4740')
      school.website.should eql('http://ahs.alameda.k12.ca.us/')
      school.nces_id.should eql('060177000041')
      school.latitude.should eql('37.764267')
      school.longitude.should eql('-122.24818')
      school.overview_link.should eql('http://www.greatschools.org/modperl/browse_school/ca/1?s_cid=gsapi')
      school.ratings_link.should eql('http://www.greatschools.org/school/rating.page?state=CA&id=1&s_cid=gsapi')
      school.reviews_link.should eql('http://www.greatschools.org/school/parentReviews.page?state=CA&id=1&s_cid=gsapi')

      school.parent_reviews.each do |review|
        review.should be_a(GreatSchools::Review)
      end
    end
  end

  describe '#search' do
    it 'should populate school models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_search.xml')
      ))
      FakeWeb.register_uri(:get, 'http://api.greatschools.org/search/schools?limit=2&q=Alameda%20Christian&state=CA&key=0123456789ABCDEF', body: xml)

      schools = GreatSchools::School.search('CA', 'Alameda Christian', limit: 2)

      schools.size.should eql(2)
      schools[0].name.should eql('Alameda Christian School')
      schools[1].name.should eql('Chinese Christian Schools-Alameda')

      school = schools.first
      school.id.should eql('8485')
      school.name.should eql('Alameda Christian School')
      school.type.should eql('private')
      school.grade_range.should eql('K-8')
      school.enrollment.should eql('52')
      school.parent_rating.should eql('5')
      school.city.should eql('Alameda')
      school.state.should eql('CA')
      school.address.should eql('2226 Pacific Ave, Alameda, CA 94501')
      school.phone.should eql('(510) 523-1000')
      school.nces_id.should eql('00079445')
      school.latitude.should eql('37.768623')
      school.longitude.should eql('-122.243965')
      school.overview_link.should eql('http://www.greatschools.org/cgi-bin/ca/private/8485?s_cid=gsapi')
      school.ratings_link.should eql('http://www.greatschools.org/school/rating.page?state=CA&id=8485&s_cid=gsapi')
      school.reviews_link.should eql('http://www.greatschools.org/school/parentReviews.page?state=CA&id=8485&s_cid=gsapi')
    end
  end

  let(:school) { GreatSchools::School.new(state: 'CA', gs_id: 1) }

  describe '.census' do
    it 'should make a GreatSchools::Census#for_school call using state/gs_id attributes' do
      GreatSchools::Census.should_receive(:for_school).with('CA', 1)

      school.census
    end
  end

  describe '.reviews' do
    it 'should make a GreatSchools::Review#for_school call using state/gs_id attributes' do
      GreatSchools::Review.should_receive(:for_school).with('CA', 1, {})

      school.reviews
    end
  end

  describe '.scores' do
    it 'should make a GreatSchools::Score#for_school call using state/gs_id attributes' do
      GreatSchools::Score.should_receive(:for_school).with('CA', 1)

      school.scores
    end
  end
end
