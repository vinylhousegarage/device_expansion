require 'test_helper'

class PostsNewViewTest < ActionDispatch::IntegrationTest
  setup do
    @users = [users(:first_poster), users(:admin)]
  end

  test 'renders user-info section with correct content' do
    @users.each do |user|
      session[:id] = user.id
      get new_post_path
      assert_user_info(user)
    end
  end

  test 'displays new registration form with correct fields' do
    session[:id] = user.id
    get new_post_path
    assert_select 'h3', text: '新規登録'
    assert_select 'form' do
      assert_select 'input[type=text][name=?]', 'post[name]'
      assert_select 'input[type=number][name=?]', 'post[amount]'
      assert_select 'input[type=text][name=?]', 'post[address]'
      assert_select 'input[type=text][name=?]', 'post[tel]'
      assert_select 'input[type=text][name=?]', 'post[others]'
      assert_select 'input[type=submit][value=?]', '　　　登　録　　　'
    end
  end

  test 'renders session ID and confirmation button' do
    @users.each do |user|
      session[:id] = user.id
      get new_post_path
      assert_select 'p', text: "sessionID: #{user.id}"
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

  test 'displays appropriate navigation buttons based on user role' do
    @users.each do |user|
      session[:id] = user.id
      get new_post_path
      if user.name == '集計担当'
        assert_select 'table' do
          assert_select 'b', text: '登録状況へ戻る　'
          assert_select 'form[action=?][method=?]', users_path, 'get' do
            assert_select 'button', '戻る'
          end
        end
      else
        assert_select 'table' do
          assert_select 'b', text: '作業を終了する　'
          assert_select 'form[action=?][method=?]', logout_users_path, 'post' do
            assert_select 'button', '終了'
          end
        end
      end
    end
  end
end
