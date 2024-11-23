class PostsController < ApplicationController
  def new
    @current_user = current_user
    @post = Post.new
    @user_stats_by_id = user_posts_stats.user_stats_by_id(session[:user_id].to_i)
  end
end
