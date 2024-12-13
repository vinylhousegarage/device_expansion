require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # home#introduction のパスをテスト
  test 'should route to introduction' do
    get root_path
    assert_response :success
  end
end
