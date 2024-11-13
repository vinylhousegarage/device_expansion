module SignInHelper
  def sign_in_as(user, path, params: { id: user.id }, as: :html, method: :post)
    send(method, path, params: params, as: as)
    assert_response :success
  end
end
