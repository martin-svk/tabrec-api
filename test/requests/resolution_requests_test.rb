require_relative '../test_helper.rb'

class ResolutionRequestsTest < MiniTest::Test
  def test_should_return_200_ok
    get '/resolutions'
    assert_equal 200, last_response.status
  end

  def test_response_should_be_json
    get '/resolutions'
    assert_equal 'application/json', last_response.headers['Content-Type']
  end

  def test_it_should_return_all_patterns
    get '/resolutions'
    resolutions = json(last_response.body)
    assert_equal Resolution.count, resolutions.size
  end
end
