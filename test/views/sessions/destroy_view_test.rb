require 'test_helper'

class SessionsDestroyViewTest < ActionView::TestCase
  def setup
    @user = users(:first_poster)
  end

  test 'renders sessions#destroy page with farewell message' do
    render template: 'sessions/destroy'
    assert_select 'h3', 'おつかれ様でした'
  end
end
