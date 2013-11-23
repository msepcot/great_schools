# GreatSchools

A Ruby interface to the GreatSchools API.

The GreatSchools API allows access to School Profiles, Test Scores, School
Reviews, GreatSchools Ratings, School Districts, and City Profiles.

Before you can start using the GreatSchool API, you must register and
request an access key at: http://www.greatschools.org/api/registration.page

## Installation

Add this line to your application's Gemfile:

    gem 'great_schools'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install great_schools

## Usage

The first call you make should setup your API key:

    GreatSchools::API.key = 'MY_API_KEY'

The first entry point is `GreatSchools::City` to lookup nearby cities; get an
overview of a specific city; and find the districts and reviews associated with
it.

    GreatSchools::City.nearby('CA', 'San Francisco') # => list of cities neighboring San Francisco, CA.

    city = GreatSchools::City.overview('CA', 'San Francisco')
    city.districts # => list of districts in San Francisco, CA
    city.reviews # => list of reviews for schools in San Francisco, CA

The second main entry point is `GreatSchools::School` to lookup schools in a
specific city or near an address; get a school profile; and find census data,
test scores, and reviews associated with it.

    schools = GreatSchools::School.browse('CA', 'San Francisco') # => list of schools

    school = GreatSchools::School.nearby('CA', zip_code: 94105).first
    school.census # => lunch pricing, student/teacher ratio, ethnicities, etc.
    school.review # => list of reviews for the school
    school.score # => GreatSchool rank and recent test results

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
