require 'test_helper'

class ApplicationControllerActionTest < ActionController::TestCase

  USER_STATS_STRUCT = Struct.new(:user_stats)

  def setup
    initialize_user
    initialize_user_stats
    stub_services
  end

  private

  def initialize_user
    @user = users(:first_poster)
    sign_in_as(@user)
  end

  def initialize_user_stats
    @user_stats = [
      { user_name: '投稿者１', post_count: 2, post_amount: 8_000 },
      { user_name: '投稿者２', post_count: 3, post_amount: 12_000 }
    ]
  end

  def stub_services
    user_stats_stub = USER_STATS_STRUCT.new(@user_stats)
    UserPostsStatsService.stubs(:new, user_stats_stub) do
      get new_post_path
    end
  end

  # current_userメソッドのテスト
  test 'current_user should return the user based on session user_id' do
    get new_post_path
    assert_response :success
    assert_equal @user.id, @controller.current_user
  end
end
