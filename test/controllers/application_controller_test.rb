class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:first_poster)
    sign_in_as(@user)
  end

  # current_userメソッドのテスト
  test 'current_user should return the user based on session user_id' do
    mock_user_posts_stats = UserPostsStatsService::UserStat.new(
      user: @user,
      user_id: @user.id,
      user_name: @user.name,
      post_count: 3,
      post_amount: 5_000
    )
    UserPostsStatsService.any_instance.stubs(:user_stats_by_id).returns(mock_user_posts_stats)
    get new_post_path
    assert_response :success
    assert_match @user.name, response.body
  end
end
