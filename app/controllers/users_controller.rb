class UsersController < ApplicationController

  # 仮に、管理者ユーザーをフィクスチャまたはデータベースから取得
  def login
    admin_user = User.find_by(name: "集計担当")
    session[:user_id] = admin_user.id
    redirect_to users_path
  end

  def new
    session[:user_id] = nil
    @users = User.where(name: User::POSTER_USERS.values)
  end
end
