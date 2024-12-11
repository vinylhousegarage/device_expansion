require 'test_helper'

class DataResetServiceTest < ActiveSupport::TestCase
  setup do
    @user = users(:first_poster)
  end

  test 'it resets the database and auto-increments' do
    assert_difference('User.count', -1) do
      assert_difference('Post.count', -1) do
        DataResetService.call
      end
    end

    assert_equal 1, ActiveRecord::Base.connection.execute('SELECT last_value FROM users_id_seq').first['last_value']
    assert_equal 1, ActiveRecord::Base.connection.execute('SELECT last_value FROM posts_id_seq').first['last_value']
  end
end
