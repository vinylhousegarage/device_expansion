class QrCodeController < ApplicationController
  before_action :set_user

  # QRコードを取得し@svgに格納
  def login_form
    @svg = QrCodeGeneratorService.generate_qr_code(@user)
  end

  # QRコードの確認
  def handle_login; end
end
