class SessionsController < ApplicationController
  # 投稿者のトップページを設定
  def login_poster
    session[:user_id] = params[:id]
    render json: { redirect_url: root_path }
  end

  # 投稿者のログアウト
  def logout_poster
    session[:user_id] = nil
  end
end
