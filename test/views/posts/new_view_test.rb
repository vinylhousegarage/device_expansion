require 'test_helper'

class UsersShowViewTest < ActionDispatch::IntegrationTest
  setup do
    @users = [users(:first_poster), users(:admin)]
  end

  test "show template displays user info and posts for different user roles" do
    @users.each do |user|
      sign_in_as(user)
      get user_path(user)
      user_posts = user.posts

      assert_select 'form' do
        assert_select 'input[type=text][name=?]', 'post[name]'
        assert_select 'input[type=number][name=?]', 'post[amount]'
        assert_select 'input[type=text][name=?]', 'post[address]'
        assert_select 'input[type=text][name=?]', 'post[tel]'
        assert_select 'input[type=text][name=?]', 'post[others]'
        assert_select 'input[type=submit][value=?]', '　　　登　録　　　'
      end

      assert_select 'div#user-info'

      if user.name == "集計担当"
        assert_select 'form[action=?][method=?]', users_path, 'get' do
          assert_select 'button', '登録状況へ戻る　'
        end
      else
        assert_select 'form[action=?][method=?]', logout_users_path, 'post' do
          assert_select 'button', '作業を終了する　'
        end
      end
    end
  end
end
