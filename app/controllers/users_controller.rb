class UsersController < ApplicationController
  # 投稿者一覧を表示
  def index
    @total_posts_count = PostsStatsService.new.calculate_posts_count
    @total_posts_amount = PostsStatsService.new.calculate_posts_amount
    @all_users_stats = UserPostsStatsService.new.all_users_stats
  end

  # 個人別投稿一覧を表示
  def show
    @user = find_user_by_id
    @all_users_stats = UserPostsStatsService.new.all_users_stats
    @user_stats_by_id = UserPostsStatsService.new.user_stats_by_id(params[:id].to_i)
  end

  # 投稿者を招待
  def new
    @poster_users = User.poster_users
  end
end
