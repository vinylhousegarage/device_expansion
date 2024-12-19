class SessionsController < ApplicationController
  before_action :set_user, only: :login

  # 投稿者のログイン
  def login
    session[:user_id] = @user.id
    redirect_to root_path
  end

  # 投稿者のログアウト
  def logout
    session[:user_id] = nil
  end
end
