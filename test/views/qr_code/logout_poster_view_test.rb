require 'test_helper'

class UsersLogoutPosterViewTest < ActionView::TestCase
  def setup
    @user = users(:first_poster)
  end

  test 'renders logout_poster page with farewell message' do
    render template: 'users/logout_poster'
    assert_select 'h3', 'おつかれ様でした'
  end
end
