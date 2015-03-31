require_relative '../test_helper.rb'

class UsageLogRequestsTest < MiniTest::Test
  def test_get_usage_logs_should_return_200_ok
    get '/logs/usage'
    assert_equal 200, last_response.status
  end

  def test_response_should_be_json
    get '/logs/usage'
    assert_equal 'application/json', last_response.headers['Content-Type']
  end

  def test_it_should_limit_to_300_logs
    get '/logs/usage'
    ulogs = json(last_response.body)
    assert ulogs.size <= 300
  end
end
