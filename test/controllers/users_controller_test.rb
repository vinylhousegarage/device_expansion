require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper
  # test "the truth" do
  #   assert true
  # end

  # テスト用の初期データを設定
  setup do
    @user = users(:first_poster)
    @users = [users(:first_poster), users(:admin)]
    @admin_user = users(:admin)
    @total_posts_count = mock_posts_stats.total_posts_count
    @total_posts_amount = mock_posts_stats.total_posts_amount
    @mock_user_stats_by_id = mock_user_stats_by_id(@user)
    @mock_all_users_stats = mock_all_users_stats(@user, @admin_user)
    sign_in_as(@user, as: :json)
  end

  # 管理者の'集計担当'ユーザーでログインするテスト
  test 'should log in admin user and redirect to users path' do
    post login_users_path
    assert_equal @admin_user.id, session[:user_id]
    assert_redirected_to users_path
  end

  # users#new のパスをテスト
  test 'should get new user page' do
    get new_user_path
    assert_response :success
  end

  # スコープ poster_users の参照をテスト
  test 'should display poster users in new action' do
    get new_user_path
    assert_select 'form[action=?]', login_form_user_path(users(:first_poster)), text: '投稿者１さんを招待する'
    assert_select 'form[action=?]', login_form_user_path(users(:second_poster)), text: '投稿者２さんを招待する'
    assert_select 'form[action=?]', login_form_user_path(users(:admin)), count: 0
  end

  # QRコードの表示をテスト
  test 'should post to login form and generate QR code' do
    svg_expected_count = 1
    post login_form_user_path(@user.id)
    assert_response :success
    assert_select 'svg', svg_expected_count
  end

  # '投稿者１'でのログインをテスト
  test 'should log in first_poster user' do
    post login_poster_user_path(@user), params: { id: @user.id }, as: :json
    assert_response :success
    assert_equal @user.id, session[:user_id].to_i
  end

  # login_poster_redirectルートとリダイレクトをテスト
  test 'should route to login_poster_redirect' do
    get login_poster_redirect_user_path(@user)
    assert_response :success
  end

  # users#index のパスをテスト
  test 'index action renders successfully with mocked services' do
    PostsStatsService.any_instance.stubs(:total_posts_count).returns(@total_posts_count)
    PostsStatsService.any_instance.stubs(:total_posts_amount).returns(@total_posts_amount)

    UserPostsStatsService.any_instance.stubs(:all_users_stats).returns(@mock_all_users_stats)

    get users_path
    assert_response :success
  end

  # users#logout のパスとフラッシュをテスト
  test 'should successfully post to logout users path' do
    delete logout_users_path
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_flash(:notice, I18n.t('notices.data_reset'))
  end

  # users#reset_database のパスをテスト
  test 'should successfully post to reset_database path' do
    delete reset_database_users_path
    assert_response :redirect
    assert_redirected_to users_path
    follow_redirect!
    assert_response :success
    assert_flash(:notice, I18n.t('notices.data_reset'))
  end

  # users#logout_poster のパスをテスト
  test 'should successfully post to logout_poster path' do
    delete logout_poster_users_path
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
