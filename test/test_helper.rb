ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require File.expand_path '../../app.rb', __FILE__

include Rack::Test::Methods

# Must have method
def app
  TabRec.new
end

# Helper methods
def json(request_body)
  JSON.parse(request_body, symbolize_names: true)
end

# TODO: Resolve test config, USE TEST DB!!! currently development DB is used.
