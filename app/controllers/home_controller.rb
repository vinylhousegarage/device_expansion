class HomeController < ApplicationController
  before_action :set_current_user

  # root を設定
  def introduction
    @current_user = nil if @current_user&.admin?
  end
end
