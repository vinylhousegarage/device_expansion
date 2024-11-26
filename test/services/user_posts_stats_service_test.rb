require 'test_helper'

class UserPostsStatsServiceTest < ActiveSupport::TestCase
  def setup
    @user = users(:first_poster)
    @admin_user = users(:admin)
    @users = [@user, @admin_user]
    @service = UserPostsStatsService.new(@users)
  end

  # all_users_statsメソッドのテスト
  test "all_users_stats returns stats for all users" do
    stats = @service.all_users_stats

    # @user のデータを確認
    user_stat = stats.find { |stat| stat.user_id == @user.id }
    assert_equal @user.name, user_stat.user_name
    assert_equal @user.posts.size, user_stat.post_count
    assert_equal @user.posts.sum(:amount), user_stat.post_amount

    # @admin_user のデータを確認
    admin_user_stat = stats.find { |stat| stat.user_id == @admin_user.id }
    assert_equal @admin_user.name, admin_user_stat.user_name
    assert_equal @admin_user.posts.size, admin_user_stat.post_count
    assert_equal @admin_user.posts.sum(:amount), admin_user_stat.post_amount
  end

  # user_stats_by_idメソッドのテスト
  test 'user_stats_by_id returns stats for a specific user' do
    stat = @service.user_stats_by_id(@user.id)

    # ユーザー1の統計が正しいか確認
    assert_equal @user.id, stat.user_id
    assert_equal @user.name, stat.user_name
    assert_equal @user.posts.size, stat.post_count
    assert_equal @user.posts.sum(:amount), stat.post_amount
  end

  # user_stats_by_idメソッドで無効なIDを渡した場合のテスト
  test 'user_stats_by_id returns nil for an invalid user_id' do
    stat = @service.user_stats_by_id(-1)
    assert_nil stat
  end
end
