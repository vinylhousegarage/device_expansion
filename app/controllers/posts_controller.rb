class PostsController < ApplicationController
  def new
    logger.debug "Session user_id: #{session[:user_id]}"
    logger.debug "Request params: #{params.inspect}"

    @user = User.find_from_session(session)
    @post = Post.new
    @posts = Post.by_user(@user.id)
  end
end
