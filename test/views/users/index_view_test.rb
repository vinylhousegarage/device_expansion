require 'test_helper'

class UsersIndexViewTest < ActionView::TestCase
  fixtures :users

  test 'renders index form' do
    @users = [users(:first_poster), users(:second_poster)]
    @user_posts = Post.where(user: @users)

    render template: 'users/index'
    assert_select 'h3', '登録状況'
    assert_select 'button', '詳細'
    assert_select 'td', text: "#{@user_posts.count}件　"
    assert_select 'td', text: "#{number_with_delimiter(@user_posts.sum(:amount))} 円　"
    @users.each do |user|
      assert_select 'td', text: user.name
      assert_select 'td', text: "#{user.posts.count}件　"
      assert_select 'td', text: "#{number_with_delimiter(user.posts.sum(:amount))} 円　"
      assert_select 'form[action=?][method=?]', user_path(user.id), 'get' do
        assert_select 'button', '詳細'
      end
    end
    assert_select 'form[action=?][method=?]', new_post_path, 'get' do
      assert_select 'button', '　参加　'
    end
    assert_select 'form[action=?][method=?]', new_user_path, 'get' do
      assert_select 'button', '　戻る　'
    end
    assert_select 'form[action=?][method=?]', reset_database_users_path, 'post' do
      assert_select 'button', 'リセット'
  end
end
