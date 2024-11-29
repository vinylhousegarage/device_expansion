require 'test_helper'

class QrCodeLogoutPosterViewTest < ActionView::TestCase
  def setup
    @user = users(:first_poster)
  end

  test 'renders logout_poster page with farewell message' do
    render template: 'qr_code/logout_poster'
    assert_select 'h3', 'おつかれ様でした'
  end
end
