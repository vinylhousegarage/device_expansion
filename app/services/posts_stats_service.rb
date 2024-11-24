class PostsStatsService
  UserStat = Struct.new(:total_posts_count, :total_posts_amount, keyword_init: true)

  def calculate_posts_count
    Post.count
  end

  def calculate_posts_amount
    Post.sum(:amount)
  end
end
