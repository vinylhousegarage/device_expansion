require 'test_helper'

class UsersLogoutPosterViewTest < ActionView::TestCase
  setup do
    @user = users(:first_poster)
  end

  test 'renders logout form' do
    render template: 'users/logout_poster'
    assert_select 'h3', 'おつかれ様でした'
  end
end
