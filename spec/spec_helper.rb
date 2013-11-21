require 'rubygems'
require 'bundler/setup'

require 'great_schools'
require 'fakeweb'

RSpec.configure do |config|
  config.before(:suite) do
    FakeWeb.allow_net_connect = false
    GreatSchools::API.key = '0123456789ABCDEF'
  end

  config.after(:suite) do
    FakeWeb.allow_net_connect = true
  end
end
