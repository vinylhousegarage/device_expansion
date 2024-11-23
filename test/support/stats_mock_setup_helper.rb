module StatsMockSetupHelper
  def mock_posts_stats
    PostsStatsService::UserStat.new(
      total_posts_count: 4,
      total_posts_amount: 58_000
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
    [
      UserPostsStatsService::UserStat.new(
        user:,
        user_id: user.id,
        user_name: user.name,
        post_count: user.posts.size,
        post_amount: user.posts.sum(:amount)
      ),
      UserPostsStatsService::UserStat.new(
        user: admin_user,
        user_id: admin_user.id,
        user_name: admin_user.name,
        post_count: admin_user.posts.size,
        post_amount: admin_user.posts.sum(:amount)
      )
    ]
  end
end
