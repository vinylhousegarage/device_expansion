class SessionsController < ApplicationController
  before_action :set_user, only: :create
  # 投稿者のログイン
  def create
    if @user
      session[:user_id] = @user.id
      render json: { message: 'User logged in', user_id: @user.id }, status: :ok
    else
      render json: { message: 'User not found' }, status: :not_found
    end
  end

  # 投稿者のログアウト
  def destroy
    session[:user_id] = nil
  end
end
