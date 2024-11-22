require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  # Structを定数に定義
  USERS_STATS_STRUCT = Struct.new(:user_stats)

  # セッションデータを設定
  def setup
    initialize_user
    initialize_all_users_stats
  end

  private

  # 初期化を設定
  def initialize_user
    @user = users(:first_poster)
    sign_in_as(@user)
  end

  # ユーザーのスタブデータを設定
  def initialize_all_users_stats
    @all_users_stats = [
      { user_name: '投稿者１', post_count: 2, post_amount: 8_000 },
      { user_name: '投稿者２', post_count: 3, post_amount: 12_000 }
    ]
  end

  # current_userメソッドのテスト
  test 'current_user should return the user based on session user_id' do
    users_stats_stubs = USERS_STATS_STRUCT.new(@all_users_stats)
    UserPostsStatsService.stubs(:new).returns(users_stats_stubs)
    get new_post_path
    assert_response :success
    assert_equal @user.id, @controller.current_user
  end

  # find_params_idメソッドのテスト
  test 'find_params_id should find user based on params[:id]' do
    get login_poster_redirect_user_path(id: @user.id)
    assert_response :success
    fetch_url_pattern = %r{fetch\('/users/#{@user.id}/login_poster'}
    assert_match fetch_url_pattern, response.body
  end

  # redirect_with_noticeメソッドのパスをテスト
  test 'redirect_with_notice redirects to the correct path' do
    delete reset_database_users_path
    assert_response :redirect
    assert_redirected_to users_path
    follow_redirect!
    assert_response :success
  end

  # redirect_with_noticeメソッドのフラッシュメッセージを確認
  test 'redirect_with_notice sets flash and displays in redirected view' do
    delete reset_database_users_path
    assert_response :redirect
    assert_redirected_to users_path
    follow_redirect!
    assert_response :success
    assert_flash(:notice, I18n.t('notices.data_reset'))
  end
end
