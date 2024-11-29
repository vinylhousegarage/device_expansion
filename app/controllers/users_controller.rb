class UsersController < ApplicationController
  # 投稿者一覧を表示
  def index
    posts_stats = PostsStatsService.new
    @total_posts_count = posts_stats.calculate_posts_count
    @total_posts_amount = posts_stats.calculate_posts_amount
    user_posts_stats = UserPostsStatsService.new
    @all_users_stats = user_posts_stats.all_users_stats
  end

  # 個人別投稿一覧を表示
  def show
    @user = find_user_by_params
    user_posts_stats = UserPostsStatsService.new
    @all_users_stats = user_posts_stats.all_users_stats
    @user_stats_by_id = user_posts_stats.user_stats_by_id(params[:id].to_i)
  end

  # 投稿者を招待
  def new
    @poster_users = User.poster_users
  end
end
