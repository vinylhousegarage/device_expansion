require 'test_helper'

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  # errors#not_found のパスをテスト
  test 'renders not_found template' do
    get '/non_existent_page'
    assert_response :not_found
    assert_template :not_found
  end
end
