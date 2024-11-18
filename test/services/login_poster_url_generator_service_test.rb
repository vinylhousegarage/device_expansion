require 'test_helper'

class LoginPosterURLGeneratorTest < ActiveSupport::TestCase
  test 'should generate correct login poster redirect URL' do
    user = users(:first_poster)
    url = LoginPosterURLGenerator.generate(user)

    expected_url = Rails.application.routes.url_helpers.login_poster_redirect_user_url(
      user,
      host: 'https://device-expansion.onrender.com'
    )

    assert_equal expected_url, url
  end
end
