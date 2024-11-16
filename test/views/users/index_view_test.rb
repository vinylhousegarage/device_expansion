require 'test_helper'

class UsersIndexViewTest < ActionView::TestCase
  def assert_user_data(user)
    assert_select 'td', text: "#{user.name}"
    assert_select 'td', text: "#{user.posts.count}件　"
    assert_select 'td', text: "#{number_with_delimiter(user.posts.sum(:amount))} 円　"
  end

  def assert_form_action(action, method, button_text)
    assert_select "form[action=?][method=?]", action, method do
      assert_select 'button', button_text
    end
  end

  test 'renders index form' do
    @users = [users(:first_poster), users(:second_poster)]
    @user_posts = Post.where(user: @users)

    render template: 'users/index'
    assert_select 'h3', '登録状況'
    assert_select 'button', '詳細'
    assert_select 'td', text: "#{@user_posts.count}件　"
    assert_select 'td', text: "#{number_with_delimiter(@user_posts.sum(:amount))} 円　"

    @users.each do |user|
      assert_user_data(user, @user_posts)
      assert_form_action(user_path(user.id), 'get', '詳細')
    end

    assert_form_action(new_post_path, 'get', '　参加　')
    assert_form_action(new_user_path, 'get', '　戻る　')
    assert_form_action(reset_database_users_path, 'post', 'リセット')
  end
end
