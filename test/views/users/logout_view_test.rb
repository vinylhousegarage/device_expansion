require 'test_helper'

class PostsNewViewTest < ActionView::TestCase
  setup do
    @users = [users(:first_poster), users(:admin)]
  end

  test 'renders logout form' do
    @users.each do |user|
      @user = user

      render template: 'users/logout'
      assert_select 'h3', 'おつかれ様でした'

      if @user.name == "集計担当"
        assert_select 'form[action=?][method=?]', new_user_path, 'get' do
          assert_select 'button', '初期画面へ戻る'
        end
      else
        assert_select 'form[action=?][method=?]', new_user_path, 'get', count: 0
      end
    end
  end
end
