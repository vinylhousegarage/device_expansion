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

  # スコープ poster_users の参照をテスト
  test 'should display poster users in new action' do
    get new_user_path
    assert_select 'form[action=?]', login_form_qr_code_path(users(:first_poster)), text: '投稿者１さんを招待する'
    assert_select 'form[action=?]', login_form_qr_code_path(users(:second_poster)), text: '投稿者２さんを招待する'
    assert_select 'form[action=?]', login_form_qr_code_path(users(:admin)), count: 0
  end

  # QRコードの表示をテスト
  test 'should post to login form and generate QR code' do
    svg_expected_count = 1
    post login_form_qr_code_path(@user.id)
    assert_response :success
    assert_select 'svg', svg_expected_count
  end

  # '投稿者１'でのログインをテスト
  test 'should log in first_poster user' do
    post login_poster_qr_code_path(@user), params: { id: @user.id }, as: :json
    assert_response :success
    assert_equal @user.id, session[:user_id].to_i
  end

  # login_poster_redirectルートとリダイレクトをテスト
  test 'should route to login_poster_redirect' do
    get login_poster_redirect_qr_code_path(@user)
    assert_response :success
  end

  # users#logout_poster のパスをテスト
  test 'should successfully post to logout_poster path' do
    delete logout_poster_qr_code_index_path
    assert_response :success
  end
end
