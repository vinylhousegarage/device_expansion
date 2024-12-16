class SessionsController < ApplicationController
  # 投稿者のログイン
  def create
    session[:user_id] = params[:id]
    redirect_to root_path
  end

  # 投稿者のログアウト
  def logout_poster
    session[:user_id] = nil
  end
end
