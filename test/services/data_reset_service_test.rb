require 'test_helper'

class DataResetServiceTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = users(:admin)
    post admin_session_path
    assert_response :redirect
  end

  test 'it resets the database and auto-increments' do
    assert_equal 6, Post.count
    assert_equal 6, User.count

    post reset_database_admin_system_path
    assert_response :redirect

    assert_equal 6, Post.count, 'Post count should match fixtures'
    assert_equal 6, User.count, 'User count should match fixtures'

    new_post = Post.create!(name: 'データリセット', amount: 3000)
    assert_equal 7, new_post.id, 'ID should continue from the correct sequence'
    assert_equal 7, Post.count, 'Post count should increase after creation'
  end
end
