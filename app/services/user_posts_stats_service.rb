class UserPostsStatsService
  def initialize(users = User.includes(:posts))
    @users = users
  end

  def user_stats
    @users.map { |user| build_user_stats(user) }
  end

  def user_stats_for_id(user_id)
    user = @users.find { |u| u.id == user_id }
    return nil unless user

    build_user_stats(user)
  end

  class << self
    private

    def build_user_stats(user)
      {
        user: user,
        user_name: user.name,
        post_count: user.posts.size,
        post_amount: user.posts.sum(:amount)
      }
    end
  end
end
