class PostsController < ApplicationController
  def new
    @current_user = current_user
    @post = Post.new
    user_posts_stats = UserPostsStatsService.new
    @user_stats = user_posts_stats.user_stats(session[:user_id])
  end
end
