class PostDestroyService
  def initialize(post)
    @post = post
    @user = post.user
  end

  def call
    if @post.destroy
      if @user.posts.count.zero?
        { path: :new_post_path, type: :notice, message_key: 'notices.all_deleted', params: nil }
      else
        { path: :user_path, type: :notice, message_key: 'notices.post_deleted', params: nil }
      end
    else
      { path: :new_post_path, type: :alert, message_key: 'alerts.delete_failed', params: nil }
    end
  end
end
