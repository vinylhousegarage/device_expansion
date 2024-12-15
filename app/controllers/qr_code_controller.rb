class QrCodeController < ApplicationController
  # QRコードを取得し@svgに格納
  def login_form
    @user = find_user_by_id
    @url = QrCodeRequestUrlGeneratorService.generate_qr_code_request_url(@user)
    @svg = QrCodeGeneratorService.generate_qr_code_request(@user)
  end
end
