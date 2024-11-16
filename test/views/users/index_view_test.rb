require 'test_helper'

class UsersIndexViewTest < ActionView::TestCase
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
    assert_select 'form[action=?][method=?]', action, method do
      assert_select 'button', button_text
    end
  end

  test 'renders index view with all elements' do
    @users = User.all
    @posts = Post.all

    render template: 'users/index'

    assert_total_heading(@posts)

    @users.each do |user|
      assert_user_index(user)
    end

    assert_button('参加', new_post_path, 'get')
    assert_button('戻る', new_user_path, 'get')
    assert_button('消去', reset_database_users_path, 'post')
  end
end
