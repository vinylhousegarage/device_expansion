class ApplicationController < ActionController::Base
  rescue_from ActionController::ParameterMissing, with: :handle_bad_request
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from StandardError, with: :handle_internal_server_error

  helper_method :set_current_user, :find_user_by_id

  # セッションの user_id に基づいて現在のユーザーを取得
  def set_current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # params[:id] に基づいてユーザーを取得
  def find_user_by_id
    User.find(params[:id])
  end

  # params[:id] に基づいて投稿を取得
  def find_post_by_id
    Post.find(params[:id])
  end

  # リダイレクト後に notice のフラッシュメッセージを表示
  # message_key に notices. が自動補完される
  def redirect_with_notice(path, message_key)
    full_message_key = "notices.#{message_key}"
    redirect_to path, notice: I18n.t(full_message_key)
  end

  # リダイレクト後に alert のフラッシュメッセージを表示
  # message_key に arert. が自動補完される
  def redirect_with_alert(path, message_key)
    full_message_key = "alerts.#{message_key}"
    redirect_to path, alert: I18n.t(full_message_key)
  end

  private

  # 400エラー発生時にログを記録しエラーページを表示
  def handle_bad_request(exception)
    Rails.logger.error "Bad Request: #{exception.message}"
    render template: 'errors/bad_request', status: :bad_request
  end

  # 404エラー発生時にログを記録しエラーページを表示
  def handle_not_found(exception)
    Rails.logger.error "Not Found: #{exception.message}"
    render template: 'errors/not_found', status: :not_found
  end
end
