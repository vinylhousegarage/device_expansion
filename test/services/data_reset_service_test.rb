require 'test_helper'

class DataResetServiceTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = users(:admin)
    post admin_session_path
    assert_response :redirect
  end

  test 'it resets the database and auto-increments' do
    assert_equal 6, Post.count, 'Post count should match fixtures (6 posts)'
    assert_equal 6, User.count, 'User count should match fixtures (6 users)'

    post reset_database_admin_system_path
    assert_response :redirect

    assert_equal 0, Post.count, 'Post count should match seeds.rb (0 posts)'
    assert_equal 6, User.count, 'User count should match seeds.rb (6 users)'

    new_post = Post.create!(name: 'データリセット', amount: 3000, user: User.first)
    assert_equal 1, new_post.id, 'ID should continue from the correct sequence (1)'
    assert_equal 1, Post.count, 'Post count should increase after creation (1 post)'

    another_post = Post.create!(name: 'サービスクラス', amount: 5000, user: User.first)
    assert_equal 2, another_post.id, 'ID should continue sequentially (2)'
    assert_equal 2, Post.count, 'Post count should match after multiple creations (2 posts)'
  end
end
