class QrCodeController < ApplicationController
  # QRコードを取得し@svgに格納
  def login_form
    @user = find_user_by_params
    @url = LoginPosterUrlGeneratorService.generate_login_poster_url(@user)
    @svg = QrCodeGeneratorService.generate_for_login_poster(@user)
  end

  # 投稿者のトップページを設定
  def login_poster
    session[:user_id] = params[:id]
    render json: { redirect_url: new_post_path }
  end

  # GETルートで受けたQRコードのパスをPOSTルートに変換
  def login_poster_redirect
    @user = find_user_by_params
  end

  # 投稿者のログアウト
  def logout_poster
    session[:user_id] = nil
  end
end
