class UsersController < ApplicationController
  before_action :set_current_user, only: :show
  before_action :set_user, only: :show

  # 投稿者一覧を表示
  def index
    @total_posts_count = PostsStatsService.new.calculate_posts_count
    @total_posts_amount = PostsStatsService.new.calculate_posts_amount
    @all_users_stats = UserPostsStatsService.new.all_users_stats
  end

  # 個人別投稿一覧を表示
  def show
    @posts = @user.posts
    @user_stats_by_id = UserPostsStatsService.new.user_stats_by_id(@user.id)
  end

  # 投稿者を招待
  def new
    @poster_users = User.poster_users
  end
end
