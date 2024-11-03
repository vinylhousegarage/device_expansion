require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:first_poster)
    cookies[:user_id] = @user.id
  end

  # current_user メソッドのテスト
  test "current_user should return the user based on session user_id" do
    post login_poster_user_path(id: @user.id)
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal new_post_path, json_response["redirect_url"]
  end

  # find_params_id メソッドのテスト
  test "find_params_id should find user based on params[:id]" do
    get login_poster_redirect_user(id: @user.id)
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal login_poster_redirect_user_path(id: @user.id), json_response["redirect_url"]
  end
end
