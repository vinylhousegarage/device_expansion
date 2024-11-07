require 'test_helper'

class UsersShowViewTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:first_poster)
    @user_posts = [
      posts(:first_post),
      posts(:second_post)
    ]
    # テストのセッションデータを設定
    sign_in_as(@user)
  end

  test "show template displays user info and posts" do
    get user_path(@user)
    assert_template 'users/show'

    # shared/user_info が表示されているか
    assert_select 'h3', text: "#{@user.name}さんの登録一覧"

    # テーブルのヘッダーが正しく表示されているか
    assert_select 'table' do
      assert_select 'th', text: 'No.'
      assert_select 'th', text: '氏　名'
      assert_select 'th', text: '金　額'
    end

    # 投稿リストが正しく表示されているか
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

    # ユーザーが管理者の場合のボタン表示
    if session[:user_id] == 6
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
      # 一般ユーザー向けのボタン確認
      assert_select 'form[action=?][method=?]', new_post_path, 'get' do
        assert_select 'button', '新規登録へ戻る'
      end
    end
  end
end
