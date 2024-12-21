require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # テスト用の初期データを設定
  def setup
    @user = users(:first_poster)
    @post = posts(:first_post)
    @second_user = users(:second_poster)
    @post_count = mock_user_stats_by_id(@user).post_count
    @post_amount = mock_user_stats_by_id(@user).post_amount
    @user_stats_by_id = mock_user_stats_by_id(@user)
  end

  # createアクションの正常時をテスト
  test 'should create post successfully' do
    post sessions_path, params: { id: @user.id }, as: :json
    assert_response :success

    assert_equal @user.id, session[:user_id], 'Session user_id is not correctly set'

    Rails.logger.debug { "Validation errors: #{@post.errors.full_messages}" }

    assert_difference 'Post.count', 1 do
      post posts_path, params: {
        post: {
          name: 'テストユーザー',
          amount: 3000,
          address: '東京都',
          tel: '08012345678',
          others: '備考'
        }
      }
    end
    assert_redirected_to new_post_path

    Rails.logger.debug { "Validation errors: #{@post.errors.full_messages}" }
  end

  # createアクションの異常時をテスト
  test 'should not create post with invalid attributes' do
    post sessions_path, params: { id: @user.id }, as: :json
    assert_response :success

    assert_equal @user.id, session[:user_id], 'Session user_id is not correctly set'

    Rails.logger.debug { "Validation errors: #{@post.errors.full_messages}" }

    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { name: '', amount: nil, address: '', tel: 'abc123', others: '' } }
    end
    assert_response :unprocessable_entity

    Rails.logger.debug { "Validation errors: #{@post.errors.full_messages}" }
  end

  # updateアクションの更新をテスト
  test 'updates the record successfully' do
    post sessions_path, params: { id: @user.id }, as: :json
    assert_response :success

    patch_params = { post: { name: 'テスト ねーむ' } }
    Rails.logger.debug { "Test Params: #{patch_params.inspect}" }

    patch post_path(@post), params: { post: { name: 'テスト ねーむ' } }
    assert_response :redirect

    Rails.logger.debug { "Response Body: #{response.body}" }
    @post.reload
    assert_equal 'テスト ねーむ', @post.name
  end

  # 更新時の認可エラーをテスト
  test 'should redirect update when user is not owner' do
    post sessions_path, params: { id: @second_user.id }, as: :json
    assert_response :success

    patch post_path(@post), params: { post: { name: "Updated Name" } }

    assert_redirected_to new_post_path
    assert_equal 'アクセスが許可されていません', flash[:alert]
  end

  # 削除時の認可エラーをテスト
  test 'should redirect destroy when user is not owner' do
    post sessions_path, params: { id: @second_user.id }, as: :json
    assert_response :success

    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end

    assert_redirected_to new_post_path
    assert_equal 'アクセスが許可されていません', flash[:alert]
  end
end
