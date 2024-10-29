class PostsController < ApplicationController
  def new
    session[:user_id] = params[:id]
    @user = User.find_from_session(session)
    @post = Post.new
    @posts = Post.by_user(@user.id)
  end
end
