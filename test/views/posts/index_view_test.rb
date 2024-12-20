require 'test_helper'

class PostsIndexViewTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper

  def setup
    @posts = Post.includes(:user).all
  end

  test 'index view renders correctly for general user' do
    get posts_path
    assert_response :success

    puts @response.body

    assert_select 'table' do
      assert_select 'tr:nth-child(1) th:nth-child(1)', text: 'No.'
      assert_select 'tr:nth-child(1) th:nth-child(2)', text: '氏名'
      assert_select 'tr:nth-child(1) th:nth-child(3)', text: '金額'
      assert_select 'tr:nth-child(1) th:nth-child(4)', text: '担当'
    end

    @posts.each_with_index do |post, index|
      assert_select "tr:nth-child(#{index + 2}) td:nth-child(1)", text: "#{index + 1}　"
      assert_select "tr:nth-child(#{index + 2}) td:nth-child(2)", text: "#{post.name}　"
      assert_select "tr:nth-child(#{index + 2}) td:nth-child(3)", text: "#{number_with_delimiter(post.amount)} 円　"
      assert_select "tr:nth-child(#{index + 2}) td:nth-child(4)", text: "#{post.user.name}　"
      assert_select 'form[action=?][method=?]', post_path(post), 'get'
    end

    assert_select 'form[action=?][method=?]', users_path, 'get' do
      assert_select 'button[type="submit"]', text: '状況'
    end
  end
end
