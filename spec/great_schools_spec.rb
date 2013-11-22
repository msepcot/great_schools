require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe GreatSchools::API do
  it 'should raise an error when our key is rejected' do
    xml = File.read(File.expand_path(
      File.join(File.dirname(__FILE__), 'fixtures', 'error.xml')
    ))
    FakeWeb.register_uri(:get, 'http://api.greatschools.org/reviews/city/CA/Foster-City?key=0123456789ABCDEF', body: xml, status: [401, 'Unauthorized'])

    expect {
      GreatSchools::API.get('reviews/city/CA/Foster-City')
    }.to raise_error(GreatSchools::Error)
  end
end
