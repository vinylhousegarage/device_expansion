class HomeController < ApplicationController
  before_action :set_current_user

  # root を設定
  def introduction
    @current_user = nil if @current_user&.admin?

    respond_to do |format|
      format.html
      format.json { render json: { message: 'Accessed the root' }, status: :ok }
    end
  end
end
