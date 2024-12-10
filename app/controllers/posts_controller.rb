class PostsController < ApplicationController
  before_action :set_current_user, oexcept: [:destroy]

  # 個人別投稿一覧を表示
  def index
    if params[:user_id].present?
      @user = find_user_by_params
      @posts = @user.posts
      @user_stats_by_id = UserPostsStatsService.new.user_stats_by_id(@user.id)
    else
      @posts = Post.by_user(@current_user)
      @user_stats_by_id = UserPostsStatsService.new.user_stats_by_id(@current_user.id)
    end
  end

  # 投稿の詳細を表示
  def show
    @post = find_post_by_params
    @user_post_index = @post.user_post_index
    @user_stats_by_id = UserPostsStatsService.new.user_stats_by_id(@current_user.id)
  end

  # 投稿フォームを表示
  def new
    @post = Post.new
    @user_stats_by_id = UserPostsStatsService.new.user_stats_by_id(@current_user.id)
  end

  # 編集フォームを表示
  def edit
    @post = find_post_by_params
    @user_post_index = @post.user_post_index
    @user_stats_by_id = UserPostsStatsService.new.user_stats_by_id(@current_user.id)
  end

  # 投稿を保存
  def create
    @post = @current_user.posts.build(post_params)
    @user_stats_by_id = UserPostsStatsService.new.user_stats_by_id(@current_user.id)
    if @post.save
      redirect_to new_post_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 編集を保存
  def update
    @post = find_post_by_params
    if @post.update(post_params)
      redirect_to post_path
    else
      render :edit
    end
  end

  # 投稿を削除
  def destroy
    @post = find_post_by_params
    @user = @post.user
    result = PostDestroyService.new(@post).call
    redirect_with_flash(send(result[:path], *Array(result[:params])), result[:type], result[:message_key])
  end

  # 属性を指定
  def post_params
    params.require(:post).permit(:name, :amount, :address, :tel, :others)
  end
end
