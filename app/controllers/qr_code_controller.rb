class QrCodeController < ApplicationController
  before_action :set_user

  # QRコードを取得し@svgに格納
  def login_form
    @url = QrCodeRequestUrlGeneratorService.generate_qr_code_request_url(@user)
    @svg = QrCodeGeneratorService.generate_qr_code_request(@user)
  end

  # QRコードの確認
  def qr_code_request
    redirect_to create_session_path(@user)
  rescue ActionController::ParameterMissing
    render :qr_code_request, status: :bad_request
  rescue ActiveRecord::RecordNotFound
    render :qr_code_request, status: :not_found
  end
end
