class QrCodeController < ApplicationController
  # QRコードを取得し@svgに格納
  def login_form
    @user = find_user_by_params
    @url = LoginPosterUrlGeneratorService.generate_login_poster_url(@user)
    @svg = QrCodeGeneratorService.generate_for_login_poster(@user)
  end
end
