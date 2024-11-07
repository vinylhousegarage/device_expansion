require 'test_helper'

class UsersShowViewTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @users = [users(:first_poster), users(:admin)]
    @user_posts = Post.where(user: @users)
  end

  test "show template displays user info and posts for different user roles" do
    @users.each do |user|
      sign_in_as(user)
      get user_path(user)

      assert_select 'h3', text: "#{user.name}さんの登録一覧"

      assert_select 'table' do
        assert_select 'th', text: 'No.'
        assert_select 'th', text: '氏　名'
        assert_select 'th', text: '金　額'
      end

      @user_posts.each_with_index do |user_post, index|
        assert_select 'tr' do
          assert_select 'td', text: (index + 1).to_s
          assert_select 'td', text: user_post.name
          assert_select 'td', text: "#{number_with_delimiter(user_post.amount)} 円"
          assert_select 'form[action=?][method=?]', post_path(user_post), 'get' do
            assert_select 'button', '詳細'
          end
        end
      end

      if user.name == "集計担当"
        assert_select 'form[action=?][method=?]', new_post_path, 'get' do
          assert_select 'button', '新規登録へ戻る'
        end
        assert_select 'form[action=?][method=?]', users_path, 'get' do
          assert_select 'button', '登録状況へ戻る'
        end
        assert_select 'form[action=?][method=?]', new_user_path, 'get' do
          assert_select 'button', '初期画面へ戻る'
        end
      else
        assert_select 'form[action=?][method=?]', new_post_path, 'get' do
          assert_select 'button', '新規登録へ戻る'
        end
      end
    end
  end
end
