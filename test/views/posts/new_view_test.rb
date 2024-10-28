require 'test_helper'

class PostsNewViewTest < ActionView::TestCase
  setup do
    @post = Post.new
  end

  test 'new post form renders correctly' do
    render template: 'posts/new'

    assert_select 'form[action=?][method=?]', posts_path, 'post' do
      assert_select 'input[type=text][name=?]', 'post[name]'
      assert_select 'input[type=number][name=?]', 'post[amount]'
      assert_select 'input[type=text][name=?]', 'post[address]'
      assert_select 'input[type=text][name=?]', 'post[tel]'
      assert_select 'input[type=text][name=?]', 'post[others]'
    end
  end
end
