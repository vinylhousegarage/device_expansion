module SignInHelper
  def sign_in_as(user_or_id, path: nil, method: :post, as: nil, controller: (defined?(@controller) ? @controller : nil))
    user_id = extract_user_id(user_or_id)

    if view_test_context? || (!respond_to?(:post) && controller)
      (controller || @controller).session[:user_id] = user_id
      return
    end

    path   ||= (defined?(sessions_path) ? sessions_path : '/sessions')
    params = { id: user_id }

    if integration_test_context? && !as.nil?
      send(method, path, params: params, as: as)
    else
      send(method, path, params: params)
    end

    assert_response :success
  end

  def admin_sign_in_as(user_or_id, path: nil, method: :post, as: nil, controller: (defined?(@controller) ? @controller : nil))
    user_id = extract_user_id(user_or_id)

    if view_test_context? || (!respond_to?(:post) && controller)
      (controller || @controller).session[:admin_user_id] = user_id
      return
    end

    path   ||= (defined?(admin_session_path) ? admin_session_path(user_id) : "/admin/sessions/#{user_id}")
    params = { id: user_id }

    if integration_test_context? && !as.nil?
      send(method, path, params: params, as: as)
    else
      send(method, path, params: params)
    end

    assert_response :redirect
  end

  private

  def view_test_context?
    defined?(ActionView::TestCase) && is_a?(ActionView::TestCase)
  end

  def integration_test_context?
    defined?(ActionDispatch::IntegrationTest) && is_a?(ActionDispatch::IntegrationTest)
  end

  def extract_user_id(user_or_id)
    case user_or_id
    when Integer then user_or_id
    when String  then Integer(user_or_id) rescue user_or_id
    when Hash    then user_or_id[:id] || user_or_id['id']
    else
      user_or_id.respond_to?(:id) ? user_or_id.id : user_or_id
    end
  end
end
