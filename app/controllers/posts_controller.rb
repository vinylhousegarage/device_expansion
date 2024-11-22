class PostsController < ApplicationController
  def new
    @current_user = current_user
    @post = Post.new
    user_posts_stats = UserPostsStatsService.new
    @user_stat = user_posts_stats.user_stats_for_id(session[:user_id])
  end
end
