require 'test_helper'

class DataResetServiceTest < ActiveSupport::TestCase
  setup do
    @user = users(:first_poster)
  end

  test 'it resets the database and auto-increments' do
    Rails.logger.debug { "User_count_before: #{User.count}" }
    Rails.logger.debug { "Post_count_before: #{Post.count}" }

    post reset_database_admin_system_path
    assert_response :redirect

    assert_difference('User.count', -1) do
      Rails.logger.debug { "User_counta_after: #{User.count}" }

      assert_difference('Post.count', -2) do
        Rails.logger.debug { "Post_count_after: #{Post.count}" }

        DataResetService.call
      end
    end

    assert_equal 1, ActiveRecord::Base.connection.execute('SELECT last_value FROM users_id_seq').first['last_value']
    assert_equal 1, ActiveRecord::Base.connection.execute('SELECT last_value FROM posts_id_seq').first['last_value']
  end
end
