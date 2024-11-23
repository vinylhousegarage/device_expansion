class PostsStatsService
  UserStat = Struct.new(:total_posts_count, :total_posts_amount, keyword_init: true)

  def total_posts_count
    Post.count
  end

  def total_posts_amount
    Post.sum(:amount)
  end
end
