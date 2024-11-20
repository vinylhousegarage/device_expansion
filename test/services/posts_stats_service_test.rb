require 'test_helper'

class PostsStatsServiceTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:first_poster)
    @user2 = users(:second_poster)
    @user3 = users(:admin)
    @posts_stats = PostsStatsService.new
  end

  test 'total_posts_count returns the total number of posts' do
    assert_equal 4, @posts_stats.total_posts_count
  end

  test 'total_posts_amount returns the total amount of all posts' do
    assert_equal 58000, @posts_stats.total_posts_amount
  end
end
