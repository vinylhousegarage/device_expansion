class HandleLoginUrlGeneratorService
  def self.generate_handle_login_url(user)
    Rails.application.routes.url_helpers.handle_login_qr_code_url(
      id: user.id
      host: 'https://device-expansion.onrender.com'
    )
  end
end
