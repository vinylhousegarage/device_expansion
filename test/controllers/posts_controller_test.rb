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
    post login_poster_qr_code_path(@user)
  end

  # find_posts_by_paramsメソッドをテスト
  test 'should successfully delete the correct post' do
    assert_difference 'Post.count', -1 do
      delete post_path(@post)
    end

    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_nil Post.find_by(id: @post.id)
  end

  # createアクションの正常時をテスト
  test 'should create post successfully' do
    post login_poster_qr_code_path(@user)
    assert_response :success
    assert_equal @user.id.to_s, session[:user_id], 'Session user_id is not correctly set'

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
    post login_poster_qr_code_path(@user)
    assert_response :success
    assert_equal @user.id.to_s, session[:user_id], 'Session user_id is not correctly set'

    Rails.logger.debug { "Validation errors: #{@post.errors.full_messages}" }

    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { name: '', amount: nil, address: '', tel: 'abc123', others: '' } }
    end
    assert_response :unprocessable_entity

    Rails.logger.debug { "Validation errors: #{@post.errors.full_messages}" }
  end

  # updateアクションの更新をテスト
  test 'updates the record successfully' do
    patch_params = { post: { name: 'テスト ねーむ' } }
    Rails.logger.debug {"Test Params: #{patch_params.inspect}"}

    patch post_path(@post), params: { post: { name: 'テスト ねーむ' } }
    assert_response :redirect

    Rails.logger.debug {"Response Body: #{response.body}"}
    @post.reload
    assert_equal 'テスト ねーむ', @post.name
  end

  # updateアクションにおける無効データの非更新を確認
  test 'does not update the record with invalid data' do
    @admin_user = users(:admin)
    post admin_session_path
    assert_response :redirect

    @current_user = @admin_user
    @admin_post = posts(:third_post)
    @user_post_index = @admin_post.user_post_index
    puts "User post index: #{@user_post_index}"
    @user_stats_by_id = UserPostsStatsService.new.user_stats_by_id(@current_user.id)
    puts "User stats by ID user_name: #{@user_stats_by_id.user_name}"
    @all_users_stats = UserPostsStatsService.new.all_users_stats
    puts "All user stats: #{@all_user_stats}"

    original_amount = @admin_post.amount
    Rails.logger.debug("Original amount before patch: #{original_amount}")

    patch post_path(@post), params: { post: { name: '' } }
    assert_response :unprocessable_entity
    assert_template :edit

    @admin_post.reload
    Rails.logger.debug("Amount after reload: #{@admin_post.amount}")

    assert_equal original_amount, @admin_post.amount
  end
end
