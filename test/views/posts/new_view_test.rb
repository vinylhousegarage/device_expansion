require 'test_helper'

class PostsNewViewTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper

  def setup
    @user = users(:first_poster)
    @admin_user = users(:admin)
    @users = [@user, @admin_user]
    @mock_all_users_stats = mock_all_users_stats(@user, @admin_user)
    sign_in_as(@user)
  end

  def assert_field_with_label(label_text, field_name, field_type)
    assert_select 'div' do
      assert_select 'label', text: label_text
      assert_select "input[type=#{field_type}][name=?]", field_name
    end
  end

  def assert_submit_button(button_text)
    assert_select 'div' do
      assert_select 'input[type=submit][value=?]', button_text
    end
  end

  def assert_navigation_buttons(user)
    sign_in_as(user)
    get new_post_path
    if user.name == '集計担当'
      assert_back_to_status_button
    else
      assert_logout_button(session_path(user))
    end
  end

  private

  def assert_back_to_status_button
    assert_select 'table' do
      assert_select 'td', text: '登録状況へ戻る　'
      assert_select 'form[action=?][method=?]', users_path, 'get' do
        assert_select 'button', text: '状況'
      end
    end
  end

  def assert_logout_button(path)
    assert_select 'table' do
      assert_select 'td', text: '作業を終了する　'
      assert_select 'form[action=?][method=?]', path, 'post' do
        assert_select 'input[name="_method"][value=?]', 'delete'
        assert_select 'button', text: '終了'
      end
    end
  end

  test 'renders user-info section with correct content' do
    @users.each do |user|
      sign_in_as(user)
      get new_post_path
      assert_user_info(user)
    end
  end

  test 'displays new registration form with correct fields' do
    sign_in_as(@user)
    get new_post_path
    assert_select 'h3', text: '新規登録'
    assert_select 'form' do
      assert_field_with_label('氏名', 'post[name]', 'text')
      assert_field_with_label('金額', 'post[amount]', 'number')
      assert_field_with_label('住所', 'post[address]', 'text')
      assert_field_with_label('電話', 'post[tel]', 'text')
      assert_field_with_label('備考', 'post[others]', 'text')
      assert_submit_button('　　　登　　録　　　')
    end
  end

  test 'renders confirmation button for all users' do
    @users.each do |user|
      sign_in_as(user)
      get new_post_path
      assert_select 'table' do
        assert_select 'td', text: '集計を確認する'
        assert_select 'form[action=?][method=?]', user_path(user), 'get' do
          assert_select 'button', text: '確認'
        end
      end
    end
  end

  test 'displays appropriate navigation buttons based on user role' do
    @users.each do |user|
      assert_navigation_buttons(user)
    end
  end

  test 'displays error messages' do
    post posts_path, params: { post: { name: '', amount: -1 } }
    assert_response :unprocessable_entity

    assert_select 'div#error_explanation' do
      assert_select 'h3', text: '2 エラーが発生しました:'
      assert_select 'ul' do
        assert_select 'li', text: '名前 を入力してください'
        assert_select 'li', text: '金額 は0以上で入力してください'
      end
    end
  end
end
