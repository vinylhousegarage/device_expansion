require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # 管理者の"集計担当"ユーザーでログインするテスト
  test 'should log in admin user and redirect to users path' do
    admin_user = users(:admin)
    post login_users_path
    assert_equal admin_user.id, session[:user_id]
    assert_redirected_to users_path
  end

  # newアクション実行時のセッションID の空チェック
  test 'should reset session in new' do
    get new_user_path
    assert_nil session[:user_id]
  end

  # ページの表示をテスト
  test 'should get new user page' do
    get new_user_path
    assert_response :success
  end

  # users.yml からフィクスチャをロード
  fixtures :users

  # スコープ poster_users の参照をテスト
  test 'should display poster users in new action' do
    get new_user_path
    assert_select 'form[action=?]', login_form_user_path(users(:first_poster)), text: '投稿者１さんを招待する'
    assert_select 'form[action=?]', login_form_user_path(users(:second_poster)), text: '投稿者２さんを招待する'
    assert_select 'form[action=?]', login_form_user_path(users(:admin)), count: 0
  end

  # 投稿者を設定
  setup do
    @user = users(:first_poster)
  end

  # QRコードの生成をテスト
  test 'should get login_form and set session' do
    post login_form_user_path(@user.id)
    assert_response :success
    assert_equal @user.id, session[:user_id], 'User ID should be stored in session'
    assert_select 'svg', true, 'QR code SVG should be present in the response'
    expected_url = "http://localhost:3000/users/#{@user.id}"
    assert_includes response.body, expected_url, 'QR code should contain the correct user URL'
    assert_template :login_form
  end
end
