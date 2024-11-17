class ApplicationController < ActionController::Base
  helper_method :current_user, :find_user_by_id

  # セッションの user_id に基づいて現在のユーザーを取得
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # params[:id] に基づいてユーザーを取得
  def find_params_id
    User.find(params[:id])
  end

  # リダイレク後にフラッシュメッセージを表示
  def redirect_with_notice(path, message_key = 'notices.data_reset')
    Rails.logger.info "Message Key: #{message_key}"
    Rails.logger.info "Translated Message: #{I18n.t(message_key)}"
    redirect_to path, notice: I18n.t(message_key)
  end
end
