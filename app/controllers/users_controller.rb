class UsersController < ApplicationController
  # 投稿者一覧を表示
  def index
    @users = User.users
    @user_posts = Post.by_user(session[:user_id])
  end

  # 個人別投稿一覧を表示
  def show
    @user = find_params_id
    @user_posts = @user.posts
  end

  # ルートのページでセッションを空にする
  def new
    session[:user_id] = nil
    @poster_users = User.poster_users
  end

  # 管理者のセッションを取得
  def login
    admin_users = User.admin_users
    session[:user_id] = admin_users.first.id if admin_users.any?
    redirect_to users_path
  end

  # QRコードを取得し@svgに格納
  def login_form
    @user = find_params_id
    @svg = @user.generate_qr_code_for_login_poster_redirect
  end

  # 投稿者のトップページを設定
  def login_poster
    session[:user_id] = params[:id]
    $stdout.puts "Session user_id set to: #{session[:user_id]}"
    @user = current_user
    render json: { redirect_url: new_post_path }
  end

  # GETルートで受けたQRコードのパスをPOSTルートに変換
  def login_poster_redirect
    @user = find_params_id
  end

  # セッションをリセット
  def logout
    session[:user_id] = nil
  end
end
