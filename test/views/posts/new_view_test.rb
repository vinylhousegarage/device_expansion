require 'test_helper'

class PostsNewViewTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper

  setup do
    @users = [users(:first_poster), users(:admin)]
  end

  def access_new_post_page(user)
    sign_in_as(user)
    get new_post_path
  end

  def assert_navigation_buttons(user)
    if user.name == '集計担当'
      assert_back_to_status_button
    else
      assert_end_work_button
    end
  end

  private

  def assert_back_to_status_button
    assert_select 'table' do
      assert_select 'b', text: '登録状況へ戻る　'
      assert_select 'form[action=?][method=?]', users_path, 'get' do
        assert_select 'button', '戻る'
      end
    end
  end

  def assert_end_work_button
    assert_select 'table' do
      assert_select 'b', text: '作業を終了する　'
      assert_select 'form[action=?]', logout_users_path do
        assert_select 'input[name="_method"][value="delete"]'
        assert_select 'button', '終了'
      end
    end
  end

  test 'renders user-info section with correct content' do
    @users.each do |user|
      access_new_post_page(user)
      assert_user_info(user)
    end
  end

  test 'displays new registration form with correct fields' do
    access_new_post_page(users(:first_poster))
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
    @users.each do |user|
      access_new_post_page(user)
      assert_select 'p', text: "sessionID: #{user.id}"
      assert_select 'table' do
        assert_select 'td', text: '集計を確認する'
        assert_select 'td' do
          assert_select 'form[action=?][method=?]', user_path(user), 'get' do
            assert_select 'button', '確認'
          end
        end
      end
    end
  end

  test 'displays appropriate navigation buttons based on user role' do
    @users.each do |user|
      access_new_post_page(user)
      assert_navigation_buttons(user)
    end
  end
end
