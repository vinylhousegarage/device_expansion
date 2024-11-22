class UserPostsStatsService
  UserStat = Struct.new(:user, :user_id, :user_name, :post_count, :post_amount, keyword_init: true)

  def initialize(users = User.includes(:posts))
    @users = users
  end

  def all_users_stats
    @users.map { |user| build_user_stat(user) }
  end

  def user_stats_by_id(user_id)
    user = @users.find { |u| u.id == user_id }
    return nil unless user

    build_user_stat(user)
  end

  private

  def build_user_stat(user)
    UserStat.new(
      user: user,
      user_id: user.id,
      user_name: user.name,
      post_count: user.posts.size,
      post_amount: user.posts.sum(:amount)
    )
  end
end
