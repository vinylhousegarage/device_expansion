require 'test_helper'

class UsersNewViewTest < ActionView::TestCase
  fixtures :users

  test 'renders the new user invitation form' do
    @users = [users(:first_poster), users(:second_poster)]
    render template: 'users/new'
    assert_select 'h3', 'みんなで香典集計'
    assert_select 'form[action=?][method=?]', login_form_user_path(users(:first_poster)), 'post' do
      assert_select 'button', '投稿者１さんを招待する'
    end
    assert_select 'form[action=?][method=?]', login_form_user_path(users(:second_poster)), 'post' do
      assert_select 'button', '投稿者２さんを招待する'
    end
  end
end
