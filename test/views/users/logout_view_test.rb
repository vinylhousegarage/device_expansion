require 'test_helper'

class PostsNewViewTest < ActionView::TestCase
  setup do
    @admin = users(:admin)
  end

  test 'renders logout form' do
    render template: 'users/logout'
    assert_select 'h3', 'おつかれ様でした'

    if @admin.name == "集計担当"
      assert_select 'form[action=?][method=?]', new_user_path, 'get' do
        assert_select 'button', '初期画面へ戻る'
      end
    end
  end
end
