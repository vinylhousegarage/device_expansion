require 'test_helper'

class PostsEditViewTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper

  setup do
    @user = users(:first_poster)
    @post = posts(:second_post)
    @post_count = mock_user_stats_by_id(@user).post_count
    @post_amount = mock_user_stats_by_id(@user).post_amount
    @user_stats_by_id = mock_user_stats_by_id(@user)
    sign_in_as(@user)
  end

  test 'edit view renders correctly for general user' do
    get edit_post_path(@post)
    assert_response :success

    assert_select 'div', text: @mock_user_stats_by_id

    assert_select 'form' do
      assert_select 'input[name=?]', 'post[name]'
      assert_select 'input[name=?]', 'post[amount]'
      assert_select 'input[name=?]', 'post[address]'
      assert_select 'input[name=?]', 'post[tel]'
      assert_select 'input[name=?]', 'post[others]'
    end

    assert_select 'div#_user_info', text: /#{@user.name}さんの登録件数：#{@post_count}件/
    formatted_post_amount = number_to_currency(@post_amount, unit: '円', delimiter: ',', format: "%n%u", precision: 0)
    assert_select 'div#_user_info', text: /#{@user.name}さんの合計金額：#{formatted_post_amount}/

    assert_select 'form[action=?][method=?]', post_path, 'get'
    assert_select 'form[action=?][method=?]', new_post_path, 'get'
  end

  test 'edit view renders additional button for aggregation user' do
    @admin_user = users(:admin)
    post admin_session_path
    puts "Session user ID: #{session[:user_id]}"
    assert_response :redirect

    @post = posts(:third_post)
    @user_stats_by_id = mock_user_stats_by_id(@admin_user)
    puts "User stats by ID user_name: #{@user_stats_by_id.user_name}"
    get edit_post_path(@post)
    puts @response.body
    assert_response :success

    assert_select 'form[action=?][method=?]', users_path, 'get'
    assert_select 'td', text: /登録状況へ戻る/
  end
end
