require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper
  # test "the truth" do
  #   assert true
  # end

  # '投稿者１'でのログインをテスト
  test 'should login first_poster user' do
    @user = users(:first_poster)
    post login_session_path(@user)
    assert_response :redirect
    assert_equal @user.id, session[:user_id].to_i
  end
end
