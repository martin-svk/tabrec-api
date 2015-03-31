require_relative '../test_helper.rb'

class RecStatsRequestsTest < MiniTest::Test
  def test_get_stats_should_return_200_ok
    get "/stats/rec"
    assert_equal 200, last_response.status
  end

  def test_response_should_be_json
    get "/stats/rec"
    assert_equal 'application/json', last_response.headers['Content-Type']
  end

  def test_get_user_rec_stats_should_return_200_ok
    get "/stats/rec/#{sample_user_id}"
    assert_equal 200, last_response.status
  end

  def test_user_rec_response_should_be_json
    get "/stats/rec/#{sample_user_id}"
    assert_equal 'application/json', last_response.headers['Content-Type']
  end
end
