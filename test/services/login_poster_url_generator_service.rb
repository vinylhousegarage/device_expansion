class LoginPosterURLGenerator
  def self.generate(user)
    Rails.application.routes.url_helpers.login_poster_redirect_user_url(
      user,
      host: 'https://device-expansion.onrender.com'
    )
  end
end
