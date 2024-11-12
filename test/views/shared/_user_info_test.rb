require 'test_helper'

class UserInfoTest < ActionView::TestCase
  setup do
    @post = Post.new
    @user = users(:first_poster)
    @user_posts = Post.where(user_id: @user.id)
  end

  test 'renders the user name with post count and total amount' do
    render template: 'posts/new'
    assert_includes rendered, "#{@user.name}さんの登録件数：#{@user_posts.count}"
    total_amount = @user_posts.sum(:amount)
    formatted_amount = ActiveSupport::NumberHelper.number_to_currency(
      total_amount,
      unit: '円',
      delimiter: ',',
      format: '%n%u',
      precision: 0
    )
    assert_includes rendered, "#{@user.name}さんの合計金額：#{formatted_amount}"
  end
end
