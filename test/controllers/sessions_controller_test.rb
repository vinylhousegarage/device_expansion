require 'test_helper'

class QrCodeControllerTest < ActionDispatch::IntegrationTest
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

  # '投稿者１'でのログインをテスト
  test 'should log in first_poster user' do
    post login_poster_session_path(@user), params: { id: @user.id }, as: :json
    assert_response :success
    assert_equal @user.id, session[:user_id].to_i
  end

  # login_poster_redirectルートとリダイレクトをテスト
  test 'should route to login_poster_redirect' do
    get login_poster_redirect_session_path(@user)
    assert_response :success
  end

  # users#logout_poster のパスをテスト
  test 'should successfully post to logout_poster path' do
    delete logout_poster_sessions_path
    assert_response :success
  end
end
