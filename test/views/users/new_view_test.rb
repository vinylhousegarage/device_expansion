require 'test_helper'

class UsersNewViewTest < ActionView::TestCase
  def setup
    @poster_users = [users(:first_poster), users(:second_poster)]
  end

  test 'renders the new user invitation form' do
    render template: 'users/new'
    assert_select 'h3', 'みんなで香典集計'
    assert_select 'form[action=?][method=?]', login_form_qr_code_path(users(:first_poster)), 'post' do
      assert_select 'button', 'ゲスト１さんを招待する'
    end
    assert_select 'form[action=?][method=?]', login_form_qr_code_path(users(:second_poster)), 'post' do
      assert_select 'button', 'ゲスト２さんを招待する'
    end
  end
end
