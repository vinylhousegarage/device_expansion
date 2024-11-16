require 'test_helper'

class UsersIndexViewTest < ActionView::TestCase
  def assert_user_data(user)
    assert_select 'td', text: user.name
    assert_select 'td', text: "#{user.posts.count}件　"
    assert_select 'td', text: "#{number_with_delimiter(user.posts.sum(:amount))} 円　"
  end

  def assert_form_action(action, method, button_text)
    assert_select 'form[action=?][method=?]', action, method do
      assert_select 'button', button_text
    end
  end

  test 'renders index form' do
    poster_user = users(:first_poster)
    admin_user = users(:admin)

    render template: 'users/index'

    assert_user_data(poster_user)
    assert_form_action(user_path(poster_user.id), 'get', '詳細')

    assert_user_data(admin_user)
    assert_form_action(user_path(admin_user.id), 'get', '詳細')

    assert_form_action(new_post_path, 'get', '　参加　')
    assert_form_action(new_user_path, 'get', '　戻る　')
    assert_form_action(reset_database_users_path, 'post', 'リセット')
  end
end
