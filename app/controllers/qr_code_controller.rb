class QrCodeController < ApplicationController
  before_action :set_user

  # QRコードを取得し@svgに格納
  def login_form
    @svg = QrCodeGeneratorService.generate_qr_code(@user)
  end

  # QRコードの確認
  def handle_login
    redirect_to login_session_path(@user)
  rescue ActionController::ParameterMissing
    render :handle_login, status: :bad_request
  rescue ActiveRecord::RecordNotFound
    render :handle_login, status: :not_found
  end
end
