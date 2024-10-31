class PostsController < ApplicationController
  def new
    @user = User.find_by(id: session[:user_id])
    @post = Post.new
    @posts = Post.by_user(@user.id)
  end
end
