require 'test_helper'

class UsersShowViewTest < ActionDispatch::IntegrationTest
  setup do
    @users = [users(:first_poster), users(:admin)]
  end

  test 'displays form fields in show template' do
    @users.each do |user|
      sign_in_as(user)
      get user_path(user)

      assert_select 'form' do
        assert_select 'input[type=text][name=?]', 'post[name]'
        assert_select 'input[type=number][name=?]', 'post[amount]'
        assert_select 'input[type=text][name=?]', 'post[address]'
        assert_select 'input[type=text][name=?]', 'post[tel]'
        assert_select 'input[type=text][name=?]', 'post[others]'
        assert_select 'input[type=submit][value=?]', '　　　登　録　　　'
      end
    end
  end

  test 'displays user info section' do
    @users.each do |user|
      sign_in_as(user)
      get user_path(user)

      assert_select 'div#user-info'
    end
  end

  test 'displays confirmation button in table' do
    @users.each do |user|
      sign_in_as(user)
      get user_path(user)

      assert_select 'table' do
        assert_select 'td', text: '集計を確認する'
        assert_select 'td' do
          assert_select 'form[action=?][method=?]', user_path(user), 'get' do
            assert_select 'button', '確認'
          end
        end
      end
    end
  end

  test 'displays navigation buttons based on user role' do
    @users.each do |user|
      sign_in_as(user)
      get user_path(user)

      if user.name == '集計担当'
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
