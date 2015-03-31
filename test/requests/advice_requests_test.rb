require_relative '../test_helper.rb'

class AdviceRequestsTest < MiniTest::Test
  def test_should_return_200_ok
    get '/advices'
    assert_equal 200, last_response.status
  end

  def test_response_should_be_json
    get '/advices'
    assert_equal 'application/json', last_response.headers['Content-Type']
  end

  def test_it_should_return_all_patterns
    get '/advices'
    advices = json(last_response.body)
    assert_equal Advice.count, advices.size
  end
end
