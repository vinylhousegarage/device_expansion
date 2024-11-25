module StatsMockSetupHelper
  def mock_posts_stats
    PostsStatsService::UserStat.new(
      total_posts_count: 5,
      total_posts_amount: 68_000
    )
  end

  def mock_user_stats_by_id(user)
    UserPostsStatsService::UserStat.new(
      user:,
      user_id: user.id,
      user_name: user.name,
      post_count: user.posts.size,
      post_amount: user.posts.sum(:amount)
    )
  end

  def mock_all_users_stats(user, admin_user)
    [build_user_stat(user), build_user_stat(admin_user)]
  end

  private

  def mock_user_stats_by_id(user, post_count: nil, post_amount: nil)
    UserPostsStatsService::UserStat.new(
      user:,
      user_id: user.id,
      user_name: user.name,
      post_count: post_count || user.posts.size,
      post_amount: post_amount || user.posts.sum(:amount)
    )
  end
end
