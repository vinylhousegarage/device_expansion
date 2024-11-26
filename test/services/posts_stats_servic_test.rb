require 'test_helper'

class PostsStatsServiceTest < ActiveSupport::TestCase
  def setup
    @service = PostsStatsService.new
  end

  # calculate_posts_countメソッドをテスト
  test "calculate_posts_count returns correct count" do
    expected_count = Post.count
    result = @service.calculate_posts_count
    assert_equal expected_count, result
  end

  # calculate_posts_countメソッドをテスト
  test "calculate_posts_amount returns correct sum of amount" do
    expected_sum = Post.sum(:amount)
    result = @service.calculate_posts_amount
    assert_equal expected_sum, result
  end
end
