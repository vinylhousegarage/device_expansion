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

  # 管理者のセッションを取得
  def login
    session[:user_id] = User.admin_users.first&.id
    redirect_to users_path
  end

  # QRコードを取得し@svgに格納
  def login_form
    @user = find_user_by_params
    @url = LoginPosterUrlGeneratorService.generate_login_poster_url(@user)
    @svg = QrCodeGeneratorService.generate_for_login_poster(@user)
  end

  # 投稿者のトップページを設定
  def login_poster
    session[:user_id] = params[:id]
    render json: { redirect_url: new_post_path }
  end

  # GETルートで受けたQRコードのパスをPOSTルートに変換
  def login_poster_redirect
    @user = find_user_by_params
  end

  # 管理者のログアウト
  def logout
    session[:user_id] = nil
    redirect_with_notice(root_path, 'notices.data_reset')
  end

  # 投稿者のログアウト
  def logout_poster
    session[:user_id] = nil
  end

  # データをリセット
  def reset_database
    redirect_with_notice(users_path, 'notices.data_reset')
  end
end
