require 'test_helper'

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  # errors#not_found のパスをテスト
  test 'should redirect to root with alert for not_found' do
    get '/non_existent_page'

    assert_redirected_to root_path

    follow_redirect!
    assert_equal 'ページが見つかりません', flash[:alert]
  end
end
