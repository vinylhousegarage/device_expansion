require 'test_helper'

class UsersIndexViewTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper

  def assert_total_heading(posts)
    assert_select 'table' do
      assert_select 'td', text: '　合　　計　　'
      assert_select 'td', text: "#{posts.count}件　"
      assert_select 'td', text: "#{number_with_delimiter(posts.sum(:amount))} 円　"
      assert_form_action(posts_path, 'get', '詳細')
    end
  end

  def assert_user_index(user)
    assert_select 'table' do
      assert_select 'td', text: user.name
      assert_select 'td', text: "#{user.posts.count}件　"
      assert_select 'td', text: "#{number_with_delimiter(user.posts.sum(:amount))} 円　"
      assert_form_action(user_path(user.id), 'get', '詳細')
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
      assert_select 'input[name=_method][value=?]', method if method != 'post'
      assert_select 'button', button_text
    end
  end

  test 'renders index view with all elements' do
    @users = User.all
    @posts = Post.all

    get users_path

    assert_total_heading(@posts)

    @users.each do |user|
      assert_user_index(user)
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
