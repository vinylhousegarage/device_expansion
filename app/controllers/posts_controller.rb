class PostsController < ApplicationController
  def new
    @current_user = current_user
    @post = Post.new
    user_posts_stats = UserPostsStatsService.new
    @user_stats_by_id = user_posts_stats.user_stats_by_id(session[:user_id].to_i)
  end

  def destroy
    @post = find_post_by_params
    @user = @post.user
    redirect_to user_path(@user)
  end
end
