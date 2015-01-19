require_relative './test_helper.rb'

class TabrecTest < MiniTest::Test

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_chrome_store_redirect
    get '/'
    assert last_response.ok?
  end
end
