module SignInHelper
  def sign_in_as(user)
    get user_path(user), params: { id: user.id }
  end
end
