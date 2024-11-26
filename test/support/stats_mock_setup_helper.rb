module StatsMockSetupHelper
  def mock_posts_stats
    total_posts = Post.all
    total_posts_count = total_posts.size
    total_posts_amount = total_posts.sum(&:amount)

    PostsStatsService::UserStat.new(
      total_posts_count: total_posts_count,
      total_posts_amount: total_posts_amount
    )
  end

  def mock_user_stats_by_id(user, post_count: nil, post_amount: nil)
    UserPostsStatsService::UserStat.new(
      user:,
      user_id: user.id,
      user_name: user.name,
      post_count: post_count || user.posts.size,
      post_amount: post_amount || user.posts.sum(:amount)
    )
  end

  def mock_all_users_stats(user, admin_user)
    [build_user_stat(user), build_user_stat(admin_user)]
  end

  private

  def build_user_stat(user)
    UserPostsStatsService::UserStat.new(
      user:,
      user_id: user.id,
      user_name: user.name,
      post_count: user.posts.size,
      post_amount: user.posts.sum(:amount)
    )
  end
end
