require 'test_helper'

class SharedUserInfoPartialTest < ActionView::TestCase
  def setup
    @user = users(:first_poster)
    @posts = Post.where(id: [posts(:first_post).id, posts(:second_post).id])
  end

  # 登録件数をテスト
  test 'renders the user name with post count' do
    render partial: 'shared/user_info', locals: { user: @user, posts: @posts }
    assert_includes rendered, "#{@user.name}さんの登録件数：#{@posts.count}"
  end

  # 合計金額をテスト
  test 'renders the user name with total amount' do
    render partial: 'shared/user_info', locals: { user: @user, posts: @posts }
    total_amount = @posts.sum(&:amount)
    formatted_amount = ActiveSupport::NumberHelper.number_to_currency(total_amount, unit: '円', delimiter: ',', format: '%n%u', precision: 0)
    assert_includes rendered, "#{@user.name}さんの合計金額：#{formatted_amount}"
  end
end
