require 'test_helper'

class DataResetServiceTest < ActiveSupport::TestCase
  test 'it resets the database and calls Rails.application.load_seed' do
    Rails.application.expects(:load_seed).once

    assert_difference('User.count', -User.count) do
      assert_difference('Post.count', -Post.count) do
        DataResetService.call
      end
    end

    assert_equal 1, ActiveRecord::Base.connection.execute('SELECT last_value FROM users_id_seq').first['last_value']
    assert_equal 1, ActiveRecord::Base.connection.execute('SELECT last_value FROM posts_id_seq').first['last_value']
  end
end
