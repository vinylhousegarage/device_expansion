class UsersController < ApplicationController

  # 仮に、管理者ユーザーをフィクスチャまたはデータベースから取得
  def login
    @user = User.admin_user
    session[:user_id] = admin_user.id
    redirect_to users_path
  end

  def new
    session[:user_id] = nil
    @users = User.poster_users
  end
end
