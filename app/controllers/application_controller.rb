class ApplicationController < ActionController::Base
  helper_method :current_user, :find_user_by_id

  # セッションの user_id に基づいて現在のユーザーを取得
  def current_user
    @current_user ||= User.find(id: session[:user_id]) if session[:user_id]
  end

  # params[:id] に基づいてユーザーを取得
  def find_user_id
    User.find(id: params[:id])
  end
end
