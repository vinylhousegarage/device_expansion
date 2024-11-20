class PostsStatsService
  def total_posts_count
    Post.count
  end

  def total_posts_amount
    Post.sum(:amount)
  end
end
