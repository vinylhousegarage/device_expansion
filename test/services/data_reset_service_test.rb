require 'test_helper'

class DataResetServiceTest < ActiveSupport::TestCase
  setup do
    @admin_user = users(:admin)
    post admin_session_path
    assert_response :redirect
  end

  test 'it resets the database and auto-increments' do
    Rails.logger.debug { "Post_count_before: #{Post.count}" }

    post reset_database_admin_system_path
    assert_response :redirect

    assert_difference('Post.count', -6) do
      Rails.logger.debug { "Post_count_after: #{Post.count}" }

      DataResetService.call
    end

    assert_equal 1, ActiveRecord::Base.connection.execute('SELECT last_value FROM posts_id_seq').first['last_value']
  end
end
