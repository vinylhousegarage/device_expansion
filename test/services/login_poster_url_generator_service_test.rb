require 'test_helper'

class LoginPosterUrlGeneratorServiceTest < ActiveSupport::TestCase
  test 'should generate correct login poster redirect URL' do
    user = users(:first_poster)
    url = LoginPosterUrlGeneratorService.generate_login_poster_url(user)

    expected_url = Rails.application.routes.url_helpers.login_poster_redirect_qr_code_url(
      user,
      host: 'https://device-expansion.onrender.com'
    )

    assert_equal expected_url, url
  end
end
