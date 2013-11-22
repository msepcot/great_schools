require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::Review do
  describe '#for_city' do
    it 'should populate review models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_reviews.xml')
      ))
      FakeWeb.register_uri(:get, 'http://api.greatschools.org/reviews/city/CA/Alameda?limit=2&key=0123456789ABCDEF', body: xml)

      reviews = GreatSchools::Review.for_city('CA', 'Alameda', 2)

      reviews.size.should eql(2)
      reviews[0].submitter.should eql('former student')
      reviews[1].submitter.should eql('parent')

      review = reviews.first
      review.school_name.should eql('Alameda High School')
      review.school_address.should eql('2201 Encinal Ave., Alameda, CA  94501')
      review.review_link.should eql('http://www.greatschools.org/school/parentReviews.page?state=CA&id=1&s_cid=gsapi&lr=true#ps398220')
      review.rating.should eql('3')
      review.submitter.should eql('former student')
      review.posted_date.should eql('2006/06/06')
      review.comments.should eql('The staff gets on the level of the students and everything is kaotic.')
    end
  end

  describe '#for_school' do
    it 'should populate review models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_reviews.xml')
      ))
      FakeWeb.register_uri(:get, 'http://api.greatschools.org/reviews/school/CA/1?limit=2&key=0123456789ABCDEF', body: xml)

      reviews = GreatSchools::Review.for_school('CA', 1, 2)

      reviews.size.should eql(2)
      reviews[0].submitter.should eql('former student')
      reviews[1].submitter.should eql('parent')

      review = reviews.first
      review.school_name.should eql('Alameda High School')
      review.school_address.should eql('2201 Encinal Ave., Alameda, CA  94501')
      review.review_link.should eql('http://www.greatschools.org/school/parentReviews.page?state=CA&id=1&s_cid=gsapi&lr=true#ps398220')
      review.rating.should eql('3')
      review.submitter.should eql('former student')
      review.posted_date.should eql('2006/06/06')
      review.comments.should eql('The staff gets on the level of the students and everything is kaotic.')
    end
  end

  it 'should populate review models from the returned XML, through a school profile' do
    xml = File.read(File.expand_path(
      File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_profile.xml')
    ))
    FakeWeb.register_uri(:get, 'http://api.greatschools.org/schools/CA/1?key=0123456789ABCDEF', body: xml)

    school = GreatSchools::School.profile('CA', 1)
    reviews = school.parent_reviews

    reviews.size.should eql(5)

    review = reviews.first
    review.school_name.should eql('Alameda High School')
    review.school_address.should eql('2201 Encinal Ave., Alameda, CA  94501')
    review.review_link.should eql('http://www.greatschools.org/school/parentReviews.page?state=CA&id=1&s_cid=gsapi&lr=true#ps398220')
    review.rating.should eql('3')
    review.submitter.should eql('former student')
    review.posted_date.should eql('2006/06/06')
    review.comments.should eql('The staff gets on the level of the students and everything is kaotic.')
  end
end
