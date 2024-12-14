class PostsController < ApplicationController
  before_action :set_current_user, oexcept: [:destroy]

  # 全ての投稿を表示
  def index
    @posts = Post.includes(:user).all
  end

  # 投稿の詳細を表示
  def show
    @post = find_post_by_id
    @user = @post.user
    @user_post_index = @post.user_post_index
    @user_stats_by_id = UserPostsStatsService.new.user_stats_by_id(@user.id)
  end

  # 投稿フォームを表示
  def new
    @post = Post.new
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

  # 編集フォームを表示
  def edit
    @post = find_post_by_id
    @user_post_index = @post.user_post_index
    @user_stats_by_id = UserPostsStatsService.new.user_stats_by_id(@current_user.id)
  end

  # 編集を保存
  def update
    @post = find_post_by_id
    if @post.update(post_params)
      redirect_with_notice(post_path, 'post_updated')
    else
      render :edit
    end
  end

  # 投稿を削除
  def destroy
    @post = find_post_by_id
    @user = @post.user

    if @post.destroy
      handle_successful_destroy
    else
      handle_failed_destroy
    end
  end

  private

  # 投稿削除成功時を定義
  def handle_successful_destroy
    if @user.posts.count.zero?
      redirect_with_notice(new_post_path, 'all_deleted')
    else
      redirect_with_notice(user_path(@user), 'post_deleted')
    end
  end

  # 投稿削除失敗時を定義
  def handle_failed_destroy
    redirect_with_alert(new_post_path, 'delete_failed')
  end

  # 属性を指定
  def post_params
    params.require(:post).permit(:name, :amount, :address, :tel, :others)
  end
end
