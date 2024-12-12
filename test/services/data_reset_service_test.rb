require 'test_helper'

class DataResetServiceTest < ActiveSupport::TestCase
  setup do
    @user = users(:first_poster)
  end

  test 'it resets the database and auto-increments' do
    Rails.logger.debug { "User_count: #{User.count}" }

    assert_difference('User.count', -1) do

      Rails.logger.debug { "User_count: #{User.count}" }
      Rails.logger.debug { "Post_count: #{Post.count}" }

      assert_difference('Post.count', -2) do

        Rails.logger.debug { "Post_count: #{Post.count}" }

        DataResetService.call
      end
    end



    assert_equal 1, ActiveRecord::Base.connection.execute('SELECT last_value FROM users_id_seq').first['last_value']
    assert_equal 1, ActiveRecord::Base.connection.execute('SELECT last_value FROM posts_id_seq').first['last_value']
  end
end
