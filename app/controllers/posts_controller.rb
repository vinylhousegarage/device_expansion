class PostsController < ApplicationController
  def new
    @current_user = current_user
    @post = Post.new
    posts_stats = PostsStatsService.new
    @total_posts_count = post_stats.total_posts_count
    @total_posts_amount = post_stats.total_posts_amount
    user_posts_stats = UserPostsStatsService.new
    @user_stats = user_posts_stats.user_stats_for_id(session[:user_id])
  end
end
