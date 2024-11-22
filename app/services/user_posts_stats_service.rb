class UserPostsStatsService
  def initialize(users = User.includes(:posts))
    @users = users
  end

  def users_stats
    @users.map { |user| build_user_stats(user) }
  end

  def user_stats(user_id)
    user = @users.find { |u| u.id == user_id }
    return nil unless user

    self.class._build_user_stats(user)
  end

  class << self
    private

    def _build_user_stats(user)
      {
        user:,
        user_name: user.name,
        post_count: user.posts.size,
        post_amount: user.posts.sum(:amount)
      }
    end
  end
end
