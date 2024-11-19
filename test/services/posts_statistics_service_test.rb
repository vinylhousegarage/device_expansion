require 'test_helper'

class PostsStatisticsServiceTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:first_poster)
    @user2 = users(:second_poster)
    @user3 = users(:admin)
    @service = PostsStatisticsService.new
  end

  test 'total_posts_count returns the total number of posts' do
    assert_equal 4, @service.total_posts_count
  end

  test 'total_posts_amount returns the total amount of all posts' do
    assert_equal 58000, @service.total_posts_amount
  end

  test 'user_statistics returns correct data for each user' do
    stats = @service.user_statistics
    user1_stat = stats.find { |s| s[:user] == @user1 }
    user2_stat = stats.find { |s| s[:user] == @user2 }
    user3_stat = stats.find { |s| s[:user] == @user3 }

    assert_equal 2, user1_stat[:post_count]
    assert_equal 8000, user1_stat[:post_amount]

    assert_equal 0, user2_stat[:post_count]
    assert_equal 0, user2_stat[:post_amount]

    assert_equal 2, user3_stat[:post_count]
    assert_equal 50000, user3_stat[:post_amount]
  end
end
