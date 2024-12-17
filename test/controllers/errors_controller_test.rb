require 'test_helper'

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  # errors#not_found のパスをテスト
  test 'renders not_found template' do
    get '/non_existent_page'
    assert_response :not_found
    assert_match '<h3>ページが見つかりません</h3>', response.body
  end
end
