require 'test_helper'

class ErrorsBadRequestViewTest < ActionView::TestCase
  test 'bad_request view renders correctly' do
    render template: 'errors/bad_request'
    assert_select 'h3', 'リクエストに問題がありました'
    assert_select 'p', 'お手数ですが'
    assert_select 'p', '最初からやり直してください'
  end
end
