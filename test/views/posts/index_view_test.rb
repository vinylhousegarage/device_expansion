require 'test_helper'

class PostsIndexViewTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper

  setup do
    @user = users(:first_poster)
    @posts = Post.includes(:user).all
    @total_posts_count = mock_posts_stats.total_posts_count
    @total_posts_amount = mock_posts_stats.total_posts_amount
    sign_in_as(@user)
  end

  test 'index view renders correctly for general user' do
    get posts_path
    assert_response :success

    puts @response.body

    formatted_post_amount = number_to_currency(@total_posts_amount, unit: ' 円', delimiter: ',', format: '%n%u', precision: 0)
    assert_select 'h3', text: /合計件数：#{@total_posts_count} 件　合計金額：#{formatted_post_amount}/

    assert_select 'table' do
      assert_select 'tr:nth-child(1) th:nth-child(1)', text: '　No.　'
      assert_select 'tr:nth-child(1) th:nth-child(2)', text: '　氏名　'
      assert_select 'tr:nth-child(1) th:nth-child(3)', text: '　金額　'
      assert_select 'tr:nth-child(1) th:nth-child(4)', text: '入力担当'
    end

    @posts.each_with_index do |post, index|
      assert_select "tr:nth-child(#{index + 2}) td:nth-child(1)", text: "#{index + 1}　"
      assert_select "tr:nth-child(#{index + 2}) td:nth-child(2)", text: "#{post.name}　"
      assert_select "tr:nth-child(#{index + 2}) td:nth-child(3)", text: "#{number_with_delimiter(post.amount)} 円　"
      assert_select "tr:nth-child(#{index + 2}) td:nth-child(4)", text: "#{post.user.name}　"
    end

    assert_select 'form[action=?][method=?]', users_path, 'get' do
      assert_select 'button[type="submit"]', text: '戻る'
    end
  end

  test 'show view renders return button for admin user' do
    @admin_user = users(:admin)
    post admin_session_path
    puts "Session user ID: #{session[:user_id]}"
    assert_response :redirect

    @posts = [posts(:third_post), posts(:forth_post), posts(:fifth_post)]
    @total_post_count = @post.size
    @total_post_amount = @posts.sum(&:amount)
    @user_stats_by_id = mock_user_stats_by_id(@admin_user)
    puts "User stats by ID user_name: #{@user_stats_by_id.user_name}"
    get posts_path
    puts @response.body
    assert_response :success

    assert_select 'form[action=?][method=?]', new_user_path, 'get' do
      assert_select 'button[type="submit"]', text: '初期画面へ戻る'
    end
  end
end
