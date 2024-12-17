class QrCodeController < ApplicationController
  # QRコードを取得し@svgに格納
  def login_form
    @user = find_user_by_id
    @url = QrCodeRequestUrlGeneratorService.generate_qr_code_request_url(@user)
    @svg = QrCodeGeneratorService.generate_qr_code_request(@user)
    rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "RecordNotFound in login_form: #{e.message}"
    render :qr_code_request, status: :not_found
  end

  # QRコードの確認
  def qr_code_request
    @user = find_user_by_id
    redirect_to create_session_path(@user)
  rescue ActionController::ParameterMissing => e
    Rails.logger.error "ParameterMissing in qr_code_request: #{e.message}"
    render :qr_code_request, status: :bad_request
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "RecordNotFound in qr_code_request: #{e.message}"
    render :qr_code_request, status: :not_found
  end
end
