module Admin
  class SystemController < ApplicationController
    before_action :ensure_admin_user, only: :reset_database

    # 投稿者別投稿一覧を表示
    def index
      @user = find_user_by_params
      @posts = @user.posts
    end

    # データベースをリセット
    def reset_database
      DataResetService.call
      redirect_with_notice(users_path, 'notices.data_reset')
    end

    private

    # 管理者の権限を確認
    def ensure_admin_user
      return if User.admin_users.pluck(:id).include?(session[:user_id])

      redirect_with_alert(root_path, 'alerts.unauthorized_access')
    end
  end
end
