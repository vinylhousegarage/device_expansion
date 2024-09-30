require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  USERS = %w[ゲスト１ ゲスト２ ゲスト３ ゲスト４ ゲスト５ 集計担当].freeze

  def test_users_exist
    USERS.each do |user_name|
      user = User.find_by(name: user_name)
      assert_not_nil user, "#{user_name} should exist in the users table"
    end
  end
end
