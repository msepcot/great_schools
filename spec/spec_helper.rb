require 'rubygems'
require 'bundler/setup'

require 'active_support/core_ext/string/filters'
require 'fakeweb'

require 'great_schools'

RSpec.configure do |config|
  config.before(:suite) do
    FakeWeb.allow_net_connect = false
    GreatSchools::API.key = '0123456789ABCDEF'
  end

  config.after(:suite) do
    FakeWeb.allow_net_connect = true
  end
end
