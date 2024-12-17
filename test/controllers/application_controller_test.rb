class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:first_poster)
    @mock_user_stats_by_id = mock_user_stats_by_id(@user)
    sign_in_as(@user)
  end

  # current_userメソッドをテスト
  test 'current_user should return the user based on session user_id' do
    UserPostsStatsService.any_instance.stubs(:user_stats_by_id).returns(@mock_user_stats_by_id)
    get new_post_path
    assert_response :success
    assert_match @user.name, response.body
  end

  # bad_request をテスト
  test 'handle_bad_request renders bad_request view' do
    post posts_path, params: {}

    assert_response :bad_request
    assert_select 'h3', 'リクエストに問題がありました'
  end

  # not_found をテスト
  test 'handle_not_found renders not_found view' do
    get user_path(id: -1)

    assert_response :not_found
    assert_select 'h3', 'ページが見つかりません'
  end

  # internal_server_error をテスト
  test 'handle_internal_server_error renders internal_server_error view' do
    get internal_server_error_simulation_path

    assert_response :internal_server_error
    assert_select 'h3', 'システムエラーが発生しました'
  end
end
