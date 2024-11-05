module JsonSignInHelper
  def json_sign_in_as(user)
    post login_poster_user_path(user.id), params: { id: user.id }, as: :json
  end
end
