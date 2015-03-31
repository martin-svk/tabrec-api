require_relative '../test_helper.rb'

class BrowsingStatsRequestsTest < MiniTest::Test
  def test_get_stats_should_return_200_ok
    get "/stats/browsing/#{sample_user_id}"
    assert_equal 200, last_response.status
  end

  def test_response_should_be_json
    get "/stats/browsing/#{sample_user_id}"
    assert_equal 'application/json', last_response.headers['Content-Type']
  end
end
