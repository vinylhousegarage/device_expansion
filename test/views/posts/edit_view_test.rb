require 'test_helper'

class PostsEditViewTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:first_poster)
    @admin_user = users(:admin)
    @post = posts(:second_post)
    @mock_user_post_index = 5
    @mock_user_stats_by_id = mock_user_stats_by_id(@user)
    sign_in_as(@user)
  end

  test 'edit view renders correctly for general user' do
    get edit_post_path(@post), params: { user_post_index: @user_post_index }

    assert_response :success
    assert_select 'div', text: /ユーザー情報/

    assert_select 'form' do
      assert_select 'input[name=?]', 'post[name]'
      assert_select 'input[name=?]', 'post[amount]'
      assert_select 'input[name=?]', 'post[address]'
      assert_select 'input[name=?]', 'post[tel]'
      assert_select 'input[name=?]', 'post[others]'
    end

    assert_select 'p', text: "登録No. #{@user_post_index}"

    assert_select 'form[action=?][method=?]', post_path(@post), 'post'
    assert_select 'form[action=?][method=?]', new_post_path, 'post'
  end

  test 'edit view renders additional button for aggregation user' do
    # モックデータで条件分岐部分をテスト
    @user_stats_by_id = OpenStruct.new(user_name: '集計担当')

    # リクエスト
    get edit_post_path(@post)

    assert_response :success

    # 集計担当用のボタン確認
    assert_select 'form[action=?][method=?]', users_path, 'post'
    assert_select 'td', text: /登録状況へ戻る/
  end
end
