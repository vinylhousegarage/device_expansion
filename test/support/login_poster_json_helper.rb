module LoginPosterJsonHelper
  def login_poster_as_json(user)
    post login_poster_user_path(user.id), params: { id: user.id }, as: :json
  end
end
