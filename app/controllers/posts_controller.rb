class PostsController < ApplicationController
  def new
    logger.debug "Session user_id: #{session[:user_id]}"
    @user = User.find_by(id: session[:user_id])
    @post = Post.new
    @posts = Post.by_user(@user.id)
  end
end
