class UsersController < ApplicationController
  # 投稿者一覧を表示
  def index
    posts_stats = PostsStatsService.new
    @total_posts_count = post_stats.total_posts_count
    @total_posts_amount = post_stats.total_posts_amount
    user_posts_stats = UserPostsStatsService.new
    @user_stats = user_posts_stats.user_stats
  end

  # 個人別投稿一覧を表示
  def show
    @user = find_params_id
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
    @user = find_params_id
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
    @user = find_params_id
  end

  # 管理者のログアウト
  def logout
    session[:user_id] = nil
    redirect_with_notice(root_path)
  end

  # 投稿者のログアウト
  def logout_poster
    session[:user_id] = nil
  end

  # データをリセット
  def reset_database
    redirect_with_notice(users_path)
  end
end
