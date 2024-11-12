require 'test_helper'

class PostsNewViewTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:first_poster)
    @user_posts = @user.posts
    sign_in_as(@user)
  end

  test 'renders user-info section with correct content' do
    get new_post_path

    assert_select 'div#user-info' do
      assert_select 'b', text: "#{@user.name}さんの登録件数：#{@user_posts.count}件"
      assert_select 'b', text: "#{@user.name}さんの合計金額：#{number_to_currency(@user_posts.sum(:amount), unit: '円', delimiter: ',', format: '%n%u', precision: 0)}"
    end
  end

  test 'displays new registration form with correct fields' do
    get new_post_path

    assert_select 'h3', text: '新規登録'
    assert_select 'form' do
      assert_select 'input[type=text][name=?]', 'post[name]'
      assert_select 'input[type=number][name=?]', 'post[amount]'
      assert_select 'input[type=text][name=?]', 'post[address]'
      assert_select 'input[type=text][name=?]', 'post[tel]'
      assert_select 'input[type=text][name=?]', 'post[others]'
      assert_select 'input[type=submit][value=?]', '　　　登　録　　　'
    end
  end

  test 'renders session ID and confirmation button' do
    get new_post_path

    assert_select 'p', text: "sessionID: #{@user.id}"
    assert_select 'table' do
      assert_select 'td', text: '集計を確認する'
      assert_select 'td' do
        assert_select 'form[action=?][method=?]', user_path(@user), 'get' do
          assert_select 'button', '確認'
        end
      end
    end
  end

  test 'displays appropriate navigation buttons based on user role' do
    get new_post_path

    if @user.name == '集計担当'
      assert_select 'table' do
        assert_select 'b', text: '登録状況へ戻る　'
        assert_select 'form[action=?][method=?]', users_path, 'get' do
          assert_select 'button', '戻る'
        end
      end
    else
      assert_select 'table' do
        assert_select 'b', text: '作業を終了する　'
        assert_select 'form[action=?][method=?]', logout_users_path, 'post' do
          assert_select 'button', '終了'
        end
      end
    end
  end
end
