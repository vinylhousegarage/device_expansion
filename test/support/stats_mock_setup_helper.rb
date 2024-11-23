module StatsMockSetupHelper
  def mock_posts_stats
    PostsStatsService::UserStat.new(
      total_posts_count: 7,
      total_posts_amount: 35_000
    )
  end

  def mock_user_stats_by_id(user)
    UserPostsStatsService::UserStat.new(
      user: user,
      user_id: user.id,
      user_name: user.name,
      post_count: 2,
      post_amount: 6_000
    )
  end

  def mock_all_users_stats(user, admin_user)
    [
      UserPostsStatsService::UserStat.new(
        user: user,
        user_id: 1,
        user_name: '投稿者１',
        post_count: 3,
        post_amount: 15_000
      ),
      UserPostsStatsService::UserStat.new(
        user: admin_user,
        user_id: 6,
        user_name: '集計担当',
        post_count: 4,
        post_amount: 20_000
      )
    ]
  end
end
