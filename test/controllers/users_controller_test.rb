require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper
  # test "the truth" do
  #   assert true
  # end

  # テスト用の初期データを設定
  def setup
    @user = users(:first_poster)
    @users = [users(:first_poster), users(:admin)]
    @admin_user = users(:admin)
    @total_posts_count = mock_posts_stats.total_posts_count
    @total_posts_amount = mock_posts_stats.total_posts_amount
    @mock_user_stats_by_id = mock_user_stats_by_id(@user)
    @mock_all_users_stats = mock_all_users_stats(@user, @admin_user)
    sign_in_as(@user, as: :json)
  end

  # users#new のパスをテスト
  test 'should get new user page' do
    get new_user_path
    assert_response :success
  end

  # スコープ poster_users の参照をテスト
  test 'should display poster users in new action' do
    get new_user_path
    assert_select 'form[action=?]', login_form_session_path(users(:first_poster)), text: '投稿者１さんを招待する'
    assert_select 'form[action=?]', login_form_session_path(users(:second_poster)), text: '投稿者２さんを招待する'
    assert_select 'form[action=?]', login_form_session_path(users(:admin)), count: 0
  end

  # users#index のパスをテスト
  test 'index action renders successfully with mocked services' do
    PostsStatsService.any_instance.stubs(:total_posts_count).returns(@total_posts_count)
    PostsStatsService.any_instance.stubs(:total_posts_amount).returns(@total_posts_amount)

    UserPostsStatsService.any_instance.stubs(:all_users_stats).returns(@mock_all_users_stats)

    get users_path
    assert_response :success
  end

  # users#show のパスと find_params_idメソッドをテスト
  test 'should successfully post to user path with current_user method' do
    UserPostsStatsService.any_instance.stubs(:user_stats_by_id).returns(@mock_user_stats_by_id)
    UserPostsStatsService.any_instance.stubs(:all_users_stats).returns(@mock_all_users_stats)
    get user_path(@user)
    assert_response :success
    assert_match @user.name, response.body
  end
end
