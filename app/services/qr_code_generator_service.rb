class QrCodeGeneratorService
  def self.generate_for_login_poster(user)
    url = LoginPosterUrlGeneratorService.generate_login_poster_url(user)
    generate_qr_code_svg(url)
  end

  class << self
    private

    def generate_qr_code_svg(url)
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
end
