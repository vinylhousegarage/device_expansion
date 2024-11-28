module Admin
  class SessionsController < ApplicationController
    # 管理者のログイン
    def create
      session[:user_id] = User.admin_users.first&.id
      redirect_to users_path
    end

    # 管理者のログアウト
    def destroy
      session[:user_id] = nil
      redirect_with_notice(root_path, 'notices.logged_out')
    end
  end
end
