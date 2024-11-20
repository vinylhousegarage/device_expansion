class PostsController < ApplicationController
  def new
    statistics_service = UserPostsStatsService.new
    
    @user = current_user
    @post = Post.new
    @user_posts = @user.posts
  end
end
