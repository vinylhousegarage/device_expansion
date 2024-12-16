class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:first_poster)
    @mock_user_stats_by_id = mock_user_stats_by_id(@user)
    sign_in_as(@user)
  end

  # current_userメソッドのテスト
  test 'current_user should return the user based on session user_id' do
    UserPostsStatsService.any_instance.stubs(:user_stats_by_id).returns(@mock_user_stats_by_id)
    get new_post_path
    assert_response :success
    assert_match @user.name, response.body
  end

  # application#handle_not_found のパスをテスト
  test 'renders handle_not_found template' do
    get '/non_existent_page'
    assert_response :not_found

    puts response.body

    assert_select 'h3', text: 'エラーが発生しました'
    assert_select 'p', text: '最初からやり直してください'
  end
end
