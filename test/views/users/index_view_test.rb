require 'test_helper'

class UsersIndexViewTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper

  def setup
    @user = users(:first_poster)
    @users = [users(:first_poster), users(:admin)]
    @admin_user = users(:admin)
    @total_posts_count = mock_posts_stats.total_posts_count
    @total_posts_amount = mock_posts_stats.total_posts_amount
    @mock_all_users_stats = mock_all_users_stats(@user, @admin_user)
    sign_in_as(@user)
    get users_path
  end

  def assert_total_heading(total_count, total_amount)
    assert_select 'table' do
      assert_select 'td', text: '　合計'
      assert_select 'td', text: "#{total_count}件　"
      assert_select 'td', text: "#{number_with_delimiter(total_amount)} 円　"
      assert_form_action(posts_path, 'get', '詳細')
    end
  end

  def assert_user_index(stat)
    assert_select 'table' do
      assert_select 'td', text: "#{stat.user_name}　"
      assert_select 'td', text: "#{stat.post_count}件　"
      assert_select 'td', text: "#{number_with_delimiter(stat.post_amount)} 円　"
      assert_form_action(user_path(stat.user_id), 'get', '詳細')
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
      assert_select 'input[name=_method]', false if method == 'post'

      assert_select 'button', button_text
    end
  end

  test 'renders index view with elements except delete button' do
    UserPostsStatsService.any_instance.stubs(:new).returns(@mock_all_users_stats)

    assert_total_heading(@total_posts_count, @total_posts_amount)

    @mock_all_users_stats.each do |stat|
      assert_user_index(stat)
    end
    assert_button('登録', new_post_path, 'get')
    assert_button('招待', new_user_path, 'get')
  end

  test 'renders delete button with correct attributes' do
    post admin_session_path
    follow_redirect!
    assert_response :success

    get users_path
    assert_response :success

    assert_button('再起', reset_database_admin_system_path, 'post')
  end

  test 'successfully resets database and redirects with flash message' do
    post admin_session_path
    follow_redirect!
    assert_response :success

    post reset_database_admin_system_path
    assert_response :redirect
    assert_redirected_to users_path
    assert_flash_set(I18n.t('notices.data_reset'))

    follow_redirect!
    assert_select 'div', text: I18n.t('notices.data_reset')
  end
end
