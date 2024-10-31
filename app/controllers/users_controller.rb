class UsersController < ApplicationController
  # 管理者のセッションを取得
  def login
    admin_users = User.admin_users
    session[:user_id] = admin_users.first.id if admin_users.any?
    redirect_to users_path
  end

  # ルートのページでセッションを空にする
  def new
    session[:user_id] = nil
    @users = User.poster_users
  end

  # QRコードを取得し@svgに格納
  def login_form
    @user = User.find(params[:id])
    @svg = @user.generate_qr_code_for_login_poster
  end

  # 投稿者のトップページを設定
  def login_poster
    session[:user_id] = params[:id]
    logger.debug "Session user_id set to: #{session[:user_id]}"
    @user = User.find(session[:user_id])
    render json: { redirect_url: new_post_path }
  end

  # GETルートで受けたQRコードのパスをPOSTルートに変換
  def login_poster_redirect
    @user = User.find(params[:id])
  end
end
