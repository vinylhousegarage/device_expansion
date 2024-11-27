module Admin
  class SystemController < ApplicationController
    before_action :ensure_admin_user, except: :login

    # データベースリセット
    def reset_database
      DataResetService.call
      redirect_with_notice(users_path, 'notices.data_reset')
    end

    private

    # 管理者権限チェック
    def ensure_admin_user
      unless User.admin_users.pluck(:id).include?(session[:user_id])
        redirect_with_alert(root_path, 'alerts.unauthorized_access')
      end
    end
  end
end
