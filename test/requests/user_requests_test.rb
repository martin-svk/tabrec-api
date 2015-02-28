require_relative '../test_helper.rb'
require 'pry'

class UserRequestsTest < MiniTest::Test
  def test_get_users_should_return_200_ok
    get '/users'
    assert_equal 200, last_response.status
  end

  def test_response_should_be_json
    get '/users'
    assert_equal 'application/json', last_response.headers['Content-Type']
  end

  def test_it_should_return_all_users
    get '/users'
    users = json(last_response.body)
    assert_equal User.count, users.size
  end
end
