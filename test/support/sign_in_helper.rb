module SignInHelper
  def sign_in_as(user, path = login_poster_user_path(user.id), params: { id: user.id }, as: :html, method: :post)
  send(method, path, params:, as:)
    assert_response :success
  end
end
