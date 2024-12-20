require 'test_helper'

class UsersShowViewTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper

  setup do
    @user = users(:first_poster)
    @posts = @user.posts
    @post_count = mock_user_stats_by_id(@user).post_count
    @post_amount = mock_user_stats_by_id(@user).post_amount
    @user_stats_by_id = mock_user_stats_by_id(@user)
    sign_in_as(@user)
  end

  test 'index view renders correctly for general user' do
    get user_path(@user)
    assert_response :success

    puts @response.body

    assert_select 'div#_user_info', text: /#{@user.name}さんの登録件数：#{@post_count}件/
    formatted_post_amount = number_to_currency(@post_amount, unit: '円', delimiter: ',', format: '%n%u', precision: 0)
    assert_select 'div#_user_info', text: /#{@user.name}さんの合計金額：#{formatted_post_amount}/

    assert_select 'table' do
      assert_select 'tr:nth-child(1) th:nth-child(1)', text: 'No.'
      assert_select 'tr:nth-child(1) th:nth-child(2)', text: '氏名'
      assert_select 'tr:nth-child(1) th:nth-child(3)', text: '金額'
    end

    @posts.each_with_index do |post, index|
      assert_select "tr:nth-child(#{index + 2}) td:nth-child(1)", text: "#{index + 1}　"
      assert_select "tr:nth-child(#{index + 2}) td:nth-child(2)", text: "#{post.name}　"
      assert_select "tr:nth-child(#{index + 2}) td:nth-child(3)", text: "#{number_with_delimiter(post.amount)} 円　"
    end

    assert_select 'form[action=?][method=?]', new_post_path, 'get' do
      assert_select 'button[type="submit"]', text: '新規'
    end
  end

  test 'show view renders return button for admin user' do
    @admin_user = users(:admin)
    post admin_session_path
    puts "Session user ID: #{session[:user_id]}"
    assert_response :redirect

    get user_path(@user)
    puts @response.body
    assert_response :success

    assert_select 'form[action=?][method=?]', users_path, 'get' do
      assert_select 'button[type="submit"]', text: '状況'
    end
  end
end
