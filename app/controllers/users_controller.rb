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
    @user = User.find_from_session(session)
    @svg = @user.generate_qr_code(session)
  end
end
