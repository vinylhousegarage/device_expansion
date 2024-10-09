require 'test_helper'

class UsersNewViewTest < ActionView::TestCase
  fixtures :users

  test "renders the new user invitation form" do
    @users = [users(:guest_1), users(:guest_2)]
    render template: 'users/new'
    assert_select 'h2', 'みんなで香典集計'
    assert_select "form[action=?][method=?]", login_form_user_path(users(:guest_1)), "post" do
      assert_select "input[type=submit][value=?]", "ゲスト1さんを招待する"
    end
    assert_select "form[action=?][method=?]", login_form_user_path(users(:guest_2)), "post" do
      assert_select "input[type=submit][value=?]", "ゲスト2さんを招待する"
    end
  end
end
