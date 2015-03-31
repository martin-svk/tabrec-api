require_relative '../test_helper.rb'

class EventRequestsTest < MiniTest::Test
  def test_should_return_200_ok
    get '/events'
    assert_equal 200, last_response.status
  end

  def test_response_should_be_json
    get '/events'
    assert_equal 'application/json', last_response.headers['Content-Type']
  end

  def test_it_should_return_all_patterns
    get '/events'
    events = json(last_response.body)
    assert_equal Event.count, events.size
  end
end
