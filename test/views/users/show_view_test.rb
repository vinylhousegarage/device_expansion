require 'test_helper'

class UsersShowViewTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper

  USER_STATS_STRUCT = Struct.new(:user_stats)

  def setup
    @users = [users(:first_poster), users(:admin)]
    initialize_user
    initialize_user_stats
    stub_services
  end

  private

  def initialize_user
    @user = users(:first_poster)
    sign_in_as(@user)
  end

  def initialize_user_stats
    @user_stats = [
      { user_name: '投稿者１', post_count: 2, post_amount: 8_000 },
      { user_name: '投稿者２', post_count: 3, post_amount: 12_000 }
    ]
  end

  def stub_services
    user_stats_stub = USER_STATS_STRUCT.new(@user_stats)
    UserPostsStatsService.stub(:new, user_stats_stub) do
      get new_post_path
    end
  end

  test 'renders user-info section with correct content' do
    @users.each do |user|
      assert_user_info(user)
    end
  end

  test 'displays headers in show template for different user roles' do
    @users.each do |user|
      sign_in_as(user)
      get user_path(user)

      assert_select 'h3', text: "#{user.name}さんの登録一覧"

      assert_select 'table' do
        assert_select 'th', text: 'No.'
        assert_select 'th', text: '氏名'
        assert_select 'th', text: '金額'
      end
    end
  end

  test 'displays user posts with correct details in show template' do
    @users.each do |user|
      sign_in_as(user)
      get user_path(user)

      user.posts.each_with_index do |user_post, index|
        assert_select 'tr' do
          assert_select 'td', text: (index + 1).to_s
          assert_select 'td', text: user_post.name
          assert_select 'td', text: "　#{number_with_delimiter(user_post.amount)} 円　"
          assert_select 'form[action=?][method=?]', post_path(user_post), 'get' do
            assert_select 'button', '詳細'
          end
        end
      end
    end
  end

  test 'displays navigation buttons based on user role in show template' do
    @users.each do |user|
      sign_in_as(user)
      get user_path(user)

      assert_select 'form[action=?][method=?]', new_post_path, 'get' do
        assert_select 'button', '新規登録へ戻る'
      end

      next if user.name == '投稿者１'

      assert_select 'form[action=?][method=?]', users_path, 'get' do
        assert_select 'button', '登録状況へ戻る'
      end
      assert_select 'form[action=?][method=?]', new_user_path, 'get' do
        assert_select 'button', '初期画面へ戻る'
      end
    end
  end
end
