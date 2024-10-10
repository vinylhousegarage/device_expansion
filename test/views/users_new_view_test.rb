require 'test_helper'

class UsersNewViewTest < ActionView::TestCase
  fixtures :users

  test "renders the new user invitation form" do
    @users = [users(:poster_1), users(:poster_2)]
    render template: 'users/new'
    assert_select 'h2', 'みんなで香典集計'
    assert_select "form[action=?][method=?]", login_form_user_path(users(:poster_1)), "post" do
      assert_select "button", "投稿者１さんを招待する"
    end
    assert_select "form[action=?][method=?]", login_form_user_path(users(:poster_2)), "post" do
      assert_select "button", "投稿者２さんを招待する"
    end
  end
end
