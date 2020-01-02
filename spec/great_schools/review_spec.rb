require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe GreatSchools::Review do
  describe '#for_city' do
    it 'should populate review models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_reviews.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/reviews/city/CA/Alameda?limit=2&key=0123456789ABCDEF', body: xml)

      reviews = GreatSchools::Review.for_city('CA', 'Alameda', limit: 2)

      expect(reviews.size).to eql(2)
      expect(reviews[0].submitter).to eql('former student')
      expect(reviews[1].submitter).to eql('parent')

      review = reviews.first
      expect(review.school_name).to eql('Alameda High School')
      expect(review.school_address).to eql('2201 Encinal Ave., Alameda, CA  94501')
      expect(review.review_link).to eql('http://www.greatschools.org/school/parentReviews.page?state=CA&id=1&s_cid=gsapi&lr=true#ps398220')
      expect(review.rating).to eql('3')
      expect(review.submitter).to eql('former student')
      expect(review.posted_date).to eql('2006/06/06')
      expect(review.comments).to eql('The staff gets on the level of the students and everything is kaotic.')
    end
  end

  describe '#for_school' do
    it 'should populate review models from the returned XML' do
      xml = File.read(File.expand_path(
        File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_reviews.xml')
      ))
      FakeWeb.register_uri(:get, 'https://api.greatschools.org/reviews/school/CA/1?limit=2&key=0123456789ABCDEF', body: xml)

      reviews = GreatSchools::Review.for_school('CA', 1, limit: 2)

      expect(reviews.size).to eql(2)
      expect(reviews[0].submitter).to eql('former student')
      expect(reviews[1].submitter).to eql('parent')

      review = reviews.first
      expect(review.school_name).to eql('Alameda High School')
      expect(review.school_address).to eql('2201 Encinal Ave., Alameda, CA  94501')
      expect(review.review_link).to eql('http://www.greatschools.org/school/parentReviews.page?state=CA&id=1&s_cid=gsapi&lr=true#ps398220')
      expect(review.rating).to eql('3')
      expect(review.submitter).to eql('former student')
      expect(review.posted_date).to eql('2006/06/06')
      expect(review.comments).to eql('The staff gets on the level of the students and everything is kaotic.')
    end
  end

  it 'should populate review models from the returned XML, through a school profile' do
    xml = File.read(File.expand_path(
      File.join(File.dirname(__FILE__), '..', 'fixtures', 'school_profile.xml')
    ))
    FakeWeb.register_uri(:get, 'https://api.greatschools.org/schools/CA/1?key=0123456789ABCDEF', body: xml)

    school = GreatSchools::School.profile('CA', 1)
    reviews = school.parent_reviews

    expect(reviews.size).to eql(5)

    review = reviews.first
    expect(review.school_name).to eql('Alameda High School')
    expect(review.school_address).to eql('2201 Encinal Ave., Alameda, CA  94501')
    expect(review.review_link).to eql('http://www.greatschools.org/school/parentReviews.page?state=CA&id=1&s_cid=gsapi&lr=true#ps398220')
    expect(review.rating).to eql('3')
    expect(review.submitter).to eql('former student')
    expect(review.posted_date).to eql('2006/06/06')
    expect(review.comments).to eql('The staff gets on the level of the students and everything is kaotic.')
  end
end
