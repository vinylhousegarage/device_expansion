require 'test_helper'

class SessionsLogoutViewTest < ActionView::TestCase
  def setup
    @user = users(:first_poster)
  end

  test 'renders sessions#logout page with farewell message' do
    render template: 'sessions/logout'
    assert_select 'h3', 'おつかれ様でした'
  end
end
