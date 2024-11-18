class QrCodeGenerator
  def self.generate_for_login_poster(user)
    login_poster_redirect_url = generate_login_poster_redirect_url(user)
    generate_qr_code_svg(login_poster_redirect_url)
  end

  private

  # login_poster_redirect のURLを取得
  def self.generate_login_poster_redirect_url(user)
    Rails.application.routes.url_helpers.login_poster_redirect_user_url(
      user,
      host: 'https://device-expansion.onrender.com'
    )
  end

  # QRコードをSVG形式で生成
  def self.generate_qr_code_svg(url)
    qrcode = RQRCode::QRCode.new(url)
    qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 3,
      standalone: true
    )
  end
end
