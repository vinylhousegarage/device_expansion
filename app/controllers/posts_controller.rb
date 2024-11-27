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
    result = PostDestroyService.new(@post).call
    redirect_with_flash(send(result[:path], *Array(result[:params])), result[:type], result[:message_key])
  end
end
