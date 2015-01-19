require File.expand_path '../test_helper.rb', __FILE__

class TabrecTest < MiniTest::Unit::TestCase

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_chrome_store_redirect
    get '/'
    assert last_response.ok?
  end
end
