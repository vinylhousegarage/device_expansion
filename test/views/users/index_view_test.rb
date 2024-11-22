require 'test_helper'

class UsersIndexViewTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper

  POSTS_STATS_STRUCT = Struct.new(:total_posts_count, :total_posts_amount)
  USERS_STATS_STRUCT = Struct.new(:user_stats)

  def setup
    initialize_user
    initialize_posts_stats
    initialize_all_users_stats
  end

  def assert_total_heading(total_count, total_amount)
    assert_select 'table' do
      assert_select 'td', text: '　合　　計　　'
      assert_select 'td', text: "#{total_count}件　"
      assert_select 'td', text: "#{number_with_delimiter(total_amount)} 円　"
      assert_form_action(posts_path, 'get', '詳細')
    end
  end

  def assert_user_index(stat)
    assert_select 'table' do
      assert_select 'td', text: stat.user_name
      assert_select 'td', text: "#{stat.post_count}件　"
      assert_select 'td', text: "#{number_with_delimiter(stat.post_amount)} 円　"
      assert_form_action(user_path(stat.user_name), 'get', '詳細')
    end
  end

  def assert_button(button_text, path, method)
    assert_select 'table' do
      assert_select 'td', text: button_text
      assert_form_action(path, method, button_text.strip)
    end
  end

  def assert_form_action(action, method, button_text)
    assert_select 'form[action=?]', action do
      assert_select 'input[name=_method][value=?]', method if method != 'get'
      assert_select 'button', button_text
    end
  end

  private

  def initialize_user
    @user = users(:first_poster)
    sign_in_as(@user)
    @users = [users(:first_poster), users(:admin)]
  end

  def initialize_posts_stats
    @total_posts_count = 4
    @total_posts_amount = 58_000
  end

  def initialize_all_users_stats
    @all_users_stats = [
      { user_name: '投稿者１', post_count: 2, post_amount: 8_000 },
      { user_name: '集計担当', post_count: 2, post_amount: 50_000 }
    ]
  end

  test 'renders index view with all elements' do
    posts_stats_stub = POSTS_STATS_STRUCT.new(@total_posts_count, @total_posts_amount)
    users_stats_stub = USERS_STATS_STRUCT.new(@all_users_stats)
    PostsStatsService.stubs(:new).returns(posts_stats_stub)
    UserPostsStatsService.stubs(:new).returns(users_stats_stub)
    get users_path

    assert_total_heading(@total_posts_count, @total_posts_amount)

    @all_users_stats.each do |stats|
      assert_user_index(stats)
    end

    assert_button('参加', new_post_path, 'get')
    assert_button('戻る', new_user_path, 'get')
    assert_button('削除', reset_database_users_path, 'delete')
  end

  test 'reset database from index view' do
    delete reset_database_users_path
    assert_flash(:notice, I18n.t('notices.data_reset'))
    follow_redirect!
    assert_select 'div', text: I18n.t('notices.data_reset')
  end
end
