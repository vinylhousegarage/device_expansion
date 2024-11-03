require 'test_helper'

class UsersNewViewTest < ActionView::TestCase
  fixtures :users

  test 'test poster login form is rendered correctly' do
    @user = users(:first_poster)
    render template: 'users/login_poster'
    assert_select 'h3', 'ようこそ'
    assert_select 'form[action=?][method=?]', new_post_path, 'get' do
      assert_select 'button', 'スタート'
    end
  end
end
