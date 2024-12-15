class QrCodeController < ApplicationController
  # QRコードを取得し@svgに格納
  def login_form
    @user = find_user_by_id
    @url = QrCodeRequestUrlGeneratorService.generate_qr_code_request_url(@user)
    @svg = QrCodeGeneratorService.generate_qr_code_request(@user)
  end

  # QRコードの確認
  def qr_code_request
    begin
      @user = find_user_by_id
      redirect_to login_poster_session_path(@user)
    rescue ActionController::ParameterMissing => e
      render :qr_code_request, status: :bad_request
    rescue ActiveRecord::RecordNotFound
      render :qr_code_request, status: :not_found
    end
  end
