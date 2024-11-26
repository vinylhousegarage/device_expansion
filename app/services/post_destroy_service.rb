class PostDestroyService
  def initialize(post)
    @post = post
  end

  def call
    if @post.destroy
      if @user.posts.count.zero?
        { path: :new_post_path }
      else
        { path: :user_path }
      end
    else
      { path: :new_post_path }
    end
  end
end
