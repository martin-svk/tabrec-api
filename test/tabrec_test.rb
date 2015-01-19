require_relative './test_helper.rb'

class TabrecTest < MiniTest::Test

  include Rack::Test::Methods

  def app
    TabRec.new
  end

  def test_chrome_store_redirect
    get '/'
    assert_equal 302, last_response.status
    follow_redirect!
    assert_equal 'https://chrome.google.com/webstore/detail/tabrec/namcfnibfapnjbnlfcijidilkgeaogde', last_request.url
  end
end
