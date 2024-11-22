require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper
  # test "the truth" do
  #   assert true
  # end

  # Structを定数に定義
  POSTS_STATS_STRUCT = Struct.new(:total_posts_count, :total_posts_amount)
  USERS_STATS_STRUCT = Struct.new(:user_stats)

  # セッションデータを設定
  setup do
    initialize_user
    initialize_posts_stats
    initialize_all_user_stats
  end

  private

  # 初期化を設定
  def initialize_user
    @user = users(:first_poster)
    @users = [users(:first_poster), users(:admin)]
    @admin_user = users(:admin)
    @posts = Post.where(user: @user)
    sign_in_as(@user, as: :json)
  end

  # 合計のスタブデータを設定
  def initialize_posts_stats
    @total_posts_count = 4
    @total_posts_amount = 58_000
  end

  # ユーザーのスタブデータを設定
  def initialize_all_user_stats
    @all_user_stats = [
      { user_name: '投稿者１', post_count: 2, post_amount: 8_000 },
      { user_name: '集計担当', post_count: 2, post_amount: 50_000 }
    ]
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
    posts_stats_stub = POSTS_STATS_STRUCT.new(@total_posts_count, @total_posts_amount)
    users_stats_stub = USERS_STATS_STRUCT.new(@all_users_stats)
    PostsStatsService.stubs(:new).returns(posts_stats_stub)
    UserPostsStatsService.stubs(:new).returns(users_stats_stub)
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
end
