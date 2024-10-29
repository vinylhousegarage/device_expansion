class PostsController < ApplicationController
  def new
    logger.debug "Session user_id: #{session[:user_id]}"
    logger.debug "Request params: #{params.inspect}"

    @user = User.find_by(id: params[:user_id])
    @post = Post.new
    @posts = Post.by_user(@user.id)
  end
end
