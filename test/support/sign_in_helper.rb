module SignInHelper
  def sign_in_as(user)
    post login_poster_qr_code_path, params: { session: { user_id: user.id } }
    assert_response :success
  end

  def admin_sign_in_as(user)
    post admin_session_path, params: { session: { user_id: user.id } }
    assert_response :success
  end
end
