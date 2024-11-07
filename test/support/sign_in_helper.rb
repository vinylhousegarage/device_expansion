module SignInHelper
  def sign_in_as(user)
    post login_path, params: { id: user.id }
  end
end
