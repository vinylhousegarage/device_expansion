require 'test_helper'

class UsersNewViewTest < ActionView::TestCase
  def setup
    @poster_users = [users(:first_poster), users(:second_poster)]
  end

  test 'renders the new user invitation form' do
    render template: 'users/new'

    assert_select 'h3', 'みんなで香典集計'

    @poster_users.each do |poster_user|
      assert_select 'table', text: /#{poster_user.name}さんを招待する/

      assert_select 'form[action=?][method=?]', login_form_qr_code_path(poster_user), 'post' do
        assert_select 'button', '招待'
      end
    end
  end
end
