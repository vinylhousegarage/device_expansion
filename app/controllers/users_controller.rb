class UsersController < ApplicationController

  # 管理者のセッションを取得
  def login
    @users = User.admin_users
    session[:user_id] = admin_users.id
    redirect_to users_path
  end

  # ルートのページでセッションを空にする
  def new
    session[:user_id] = nil
    @users = User.poster_users
  end
end
