require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper
  # test "the truth" do
  #   assert true
  # end

  # 投稿者を設定
  setup do
    @user = users(:first_poster)
    @admin_user = users(:admin)
    @posts = Post.where(user: @user)
    sign_in_as(@user, as: :json)
  end

  # 管理者の"集計担当"ユーザーでログインするテスト
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

  # users.yml からフィクスチャをロード
  fixtures :users

  # スコープ poster_users の参照をテスト
  test 'should display poster users in new action' do
    get new_user_path
    assert_select 'form[action=?]', login_form_user_path(users(:first_poster)), text: '投稿者１さんを招待する'
    assert_select 'form[action=?]', login_form_user_path(users(:second_poster)), text: '投稿者２さんを招待する'
    assert_select 'form[action=?]', login_form_user_path(users(:admin)), count: 0
  end

  # QRコードの生成をテスト
  test 'should post to login form and generate QR code' do
    svg_expected_count = 1
    post login_form_user_path(@user.id)
    assert_response :success
    assert_select 'svg', svg_expected_count
  end

  # "投稿者１"でのログインをテスト
  test 'should log in first_poster user' do
    post login_poster_user_path(@user), params: { id: @user.id }, as: :json
    assert_response :success
    assert_equal @user.id, session[:user_id].to_i
  end

  # login_poster_redirectルートとリダイレクトを確認
  test 'should route to login_poster_redirect' do
    get login_poster_redirect_user_path(@user)
    assert_response :success
  end

  # indexルートと一覧表示を確認
  test 'should display all users and their posts on index page' do
    get users_path
    assert_response :success

    User.find_each do |user|
      assert_match user.name, response.body
    end

    user_posts_total_amount = "#{number_with_delimiter(Post.where(user_id: @user.id).sum(:amount))} 円"
    assert_match user_posts_total_amount, response.body
  end

  # users#logout のパスとフラッシュをテスト
  test 'should successfully post to logout users path' do
    delete logout_users_path
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_flash :notice, I18n.t('notices.data_reset')
  end

  # users#reset_database のパスをテスト
  test 'should successfully post to reset_database path' do
    delete reset_database_users_path
    assert_response :redirect
    assert_redirected_to users_path
    follow_redirect!
    assert_response :success
    assert_flash :notice, I18n.t('notices.data_reset')
  end

  # users#logout_poster のパスをテスト
  test 'should successfully post to logout_poster path' do
    delete logout_poster_users_path
    assert_response :success
  end
end
