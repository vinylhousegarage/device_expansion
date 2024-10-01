require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "creates post with valid user_id" do
    user = User.find_by(name: "ゲスト１")
    assert_not_nil user, "User with name 'ゲスト１' not found"
    post = Post.create!(name: "Test Post", user_id: user.id)

    assert post.valid?
  end
end
