class PostsController < ApplicationController
  before_action :set_current_user, oexcept: [:destroy]

  def show
    @post = find_post_by_params
    @user_post_index = @post.user_post_index
    @user_stats_by_id = UserPostsStatsService.new.user_stats_by_id(@current_user.id)
  end

  def new
    @post = Post.new
    @user_stats_by_id = UserPostsStatsService.new.user_stats_by_id(@current_user.id)
  end

  def edit
    @post = find_post_by_params
    @user_post_index = @post.user_post_index
    @user_stats_by_id = UserPostsStatsService.new.user_stats_by_id(@current_user.id)
  end

  def create
    @post = @current_user.posts.build(post_params)
    @user_stats_by_id = UserPostsStatsService.new.user_stats_by_id(@current_user.id)
    if @post.save
      redirect_to new_post_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post = find_post_by_params
    if @post.update(post_params)
      redirect_to user_path(@current_user)
    else
      render :edit
    end
  end

  def destroy
    @post = find_post_by_params
    @user = @post.user
    result = PostDestroyService.new(@post).call
    redirect_with_flash(send(result[:path], *Array(result[:params])), result[:type], result[:message_key])
  end

  def post_params
    params.require(:post).permit(:name, :amount, :address, :tel, :others)
  end
end
