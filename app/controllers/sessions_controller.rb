class SessionsController < ApplicationController
  before_action :set_user, only: :create

  # 投稿者のログイン
  def create
    session[:user_id] = params[:id]
    redirect_to root_path
  end

  # 投稿者のログアウト
  def destroy
    session[:user_id] = nil
  end
end
