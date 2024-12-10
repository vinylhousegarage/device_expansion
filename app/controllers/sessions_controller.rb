class SessionsController < ApplicationController
  # GETルートで受けたQRコードのパスをPOSTルートに変換
  def login_poster_redirect
    @user = find_user_by_id
  end

  # 投稿者のトップページを設定
  def login_poster
    session[:user_id] = params[:id]
    render json: { redirect_url: new_post_path }
  end

  # 投稿者のログアウト
  def logout_poster
    session[:user_id] = nil
  end
end
