class PostsController < ApplicationController
  def new
    $stdout.puts "Session user_id: #{session[:user_id]}"
    @user = current_user
    @post = Post.new
    @user_posts = @user.posts
  end
end
