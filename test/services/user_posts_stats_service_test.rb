require 'test_helper'

class UserPostsStatsServiceTest < ActiveSupport::TestCase
  def setup
    @users = [
      users(:first_poster),
      users(:second_poster),
      users(:admin)
    ]
    @user_posts_stats = UserPostsStatsService.new
  end

  test 'user_stats_for_id returns correct data for each user' do
    expected_stats = {
      first_poster: { post_count: 2, post_amount: 8_000 },
      second_poster: { post_count: 0, post_amount: 0 },
      admin: { post_count: 2, post_amount: 50_000 }
    }

    @users.each do |user|
      stats = @user_posts_stats.user_stats_for_id(user.id)
      expected = expected_stats[user.name.parameterize.underscore.to_sym]

      assert_equal user, stats[:user]
      assert_equal expected[:post_count], stats[:post_count]
      assert_equal expected[:post_amount], stats[:post_amount]
    end
  end
end
