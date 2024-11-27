module Admin
  class SystemController < ApplicationController
    before_action :ensure_admin_user, except: :login

    # 管理者ログイン
    def login
      session[:user_id] = User.admin_users.first&.id
      redirect_to users_path
    end

    # 管理者ログアウト
    def logout
      session[:user_id] = nil
      redirect_with_notice(root_path, 'notices.data_reset')
    end

    # データベースリセット
    def reset_database
      DataResetService.call
      redirect_with_notice(users_path, 'notices.data_reset')
    end

    private

    # 管理者権限チェック
    def ensure_admin_user
      unless User.admin_users.pluck(:id).include?(session[:user_id])
        redirect_with_alert(root_path, 'errors.unauthorized_access')
      end
    end
  end
end
