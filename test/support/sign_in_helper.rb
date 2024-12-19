module SignInHelper
  def sign_in_as(user, path = login_session_path(user.id), params: { id: user.id }, as: :html, method: :post)
    send(method, path, params:, as:)
    assert_response :redirect
  end

  def admin_sign_in_as(user, path = admin_session_path(user.id), params: { id: user.id }, as: :html, method: :post)
    send(method, path, params:, as:)
    assert_response :redirect
  end
end
