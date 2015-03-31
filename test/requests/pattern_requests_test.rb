require_relative '../test_helper.rb'

class PatternRequestsTest < MiniTest::Test
  def test_should_return_200_ok
    get '/patterns'
    assert_equal 200, last_response.status
  end

  def test_response_should_be_json
    get '/patterns'
    assert_equal 'application/json', last_response.headers['Content-Type']
  end

  def test_it_should_return_all_patterns
    get '/patterns'
    patterns = json(last_response.body)
    assert_equal Pattern.count, patterns.size
  end
end
