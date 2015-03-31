require_relative '../test_helper.rb'

class LogRequestsTest < MiniTest::Test
  def test_get_logs_should_return_200_ok
    get '/logs/rec'
    assert_equal 200, last_response.status
  end

  def test_response_should_be_json
    get '/logs/rec'
    assert_equal 'application/json', last_response.headers['Content-Type']
  end

  def test_it_should_limit_to_300_logs
    get '/logs/rec'
    logs = json(last_response.body)
    assert logs.size <= 300
  end
end
