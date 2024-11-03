require 'test_helper'

class PostsNewViewTest < ActionView::TestCase
  setup do
    @post = Post.new
    @user = users(:first_poster)
    @posts = Post.where(user_id: @user.id)
  end

  test 'new post form renders correctly' do
    render template: 'posts/new'

    assert_select 'form' do
      assert_select 'input[type=text][name=?]', 'post[name]'
      assert_select 'input[type=number][name=?]', 'post[amount]'
      assert_select 'input[type=text][name=?]', 'post[address]'
      assert_select 'input[type=text][name=?]', 'post[tel]'
      assert_select 'input[type=text][name=?]', 'post[others]'
    end

    assert_select 'div#user-info'
  end
end
