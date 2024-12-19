class QrCodeRequestUrlGeneratorService
  def self.generate_qr_code_request_url(user)
    Rails.application.routes.url_helpers.qr_code_request_qr_code_url(
      user,
      host: 'https://device-expansion.onrender.com'
    )
  end
end
