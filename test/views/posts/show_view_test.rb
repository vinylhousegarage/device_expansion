require 'test_helper'

class PostsShowViewTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper

  setup do
    @user = users(:first_poster)
    @post = posts(:second_post)
    @post_count = mock_user_stats_by_id(@user).post_count
    @post_amount = mock_user_stats_by_id(@user).post_amount
    @user_stats_by_id = mock_user_stats_by_id(@user)
    @user_post_index = @post.user_post_index
    sign_in_as(@user)
  end

  test 'show view renders correctly for general user' do
    get post_path(@post)
    assert_response :success

    assert_select 'div#_user_info', text: /#{@user.name}さんの登録件数：#{@post_count}件/
    formatted_post_amount = number_to_currency(@post_amount, unit: '円', delimiter: ',', format: "%n%u", precision: 0)
    assert_select 'div#_user_info', text: /#{@user.name}さんの合計金額：#{formatted_post_amount}/

    assert_select 'div', text: /登録No. #{@user_post_index}件/

    assert_select 'table' do
      assert_select 'tr:nth-child(1) td:nth-child(1)', text: '氏名：'
      assert_select 'tr:nth-child(1) td:nth-child(2)', text: @post.name

      assert_select 'tr:nth-child(2) td:nth-child(1)', text: '金額'
      assert_select 'tr:nth-child(2) td:nth-child(2)',
        text: /#{Regexp.escape(number_to_currency(@post.amount, unit: "円", precision: 0, format: "%n%u"))}/

      assert_select 'tr:nth-child(3) td:nth-child(1)', text: '住所'
      assert_select 'tr:nth-child(3) td:nth-child(2)', text: @post.address

      assert_select 'tr:nth-child(4) td:nth-child(1)', text: '電話'
      assert_select 'tr:nth-child(4) td:nth-child(2)', text: @post.tel

      assert_select 'tr:nth-child(5) td:nth-child(1)', text: '備考'
      assert_select 'tr:nth-child(5) td:nth-child(2)', text: @post.others
    end

    assert_select 'form[action=?][method=?]', edit_post_path(@post), 'get' do
      assert_select 'input[type="submit"][value=?]', '投稿を編集する'
    end

    assert_select 'form[action=?][method=?]', post_path(@post), 'post' do
      assert_select 'input[type="hidden"][name="_method"][value="delete"]'
      assert_select 'input[type="submit"][value=?]', '投稿を削除する'
    end

    assert_select 'form[action=?][method=?]', user_path(@user), 'get' do
      assert_select 'input[type="submit"][value=?]', '登録一覧へ戻る'
    end
  end

  test 'edit view renders additional button for aggregation user' do
    @admin_user = users(:admin)
    post admin_session_path
    puts "Session user ID: #{session[:user_id]}"
    assert_response :redirect

    @admin_post = posts(:third_post)
    @user_stats_by_id = mock_user_stats_by_id(@admin_user)
    puts "User stats by ID user_name: #{@user_stats_by_id.user_name}"
    get post_path(@admin_post)
    puts @response.body
    assert_response :success

    assert_select 'form[action=?][method=?]', users_path, 'get' do
      assert_select 'input[type="submit"][value=?]', '登録状況へ戻る'
    end

    assert_select 'form[action=?][method=?]', new_post_path, 'get' do
      assert_select 'input[type="submit"][value=?]', '新規登録へ戻る'
    end
  end
end
