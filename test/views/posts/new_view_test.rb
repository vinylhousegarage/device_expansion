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
      assert_logout_button(logout_users_path)
    else
      assert_logout_button(logout_poster_users_path)
    end
  end

  private

  def assert_back_to_status_button
    assert_select 'table' do
      assert_select 'td', text: '登録状況へ戻る　'
      assert_select 'form[action=?][method=?]', users_path, 'get' do
        assert_select 'button', text: '戻る'
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
      access_new_post_page(user)
      assert_user_info(user)
    end
  end

  test 'displays new registration form with correct fields' do
    access_new_post_page(users(:first_poster))
    assert_select 'h3', text: '新規登録'
    assert_select 'form' do
      assert_select 'div' do
        assert_select 'label', text: '氏名'
        assert_select 'input[type=text][name=?]', 'post[name]'
      end
      assert_select 'div' do
        assert_select 'label', text: '金額'
        assert_select 'input[type=number][name=?]', 'post[amount]'
      end
      assert_select 'div' do
        assert_select 'label', text: '住所'
        assert_select 'input[type=text][name=?]', 'post[address]'
      end
      assert_select 'div' do
        assert_select 'label', text: '電話'
        assert_select 'input[type=text][name=?]', 'post[tel]'
      end
      assert_select 'div' do
        assert_select 'label', text: '備考'
        assert_select 'input[type=text][name=?]', 'post[others]'
      end
      assert_select 'div' do
        assert_select 'input[type=submit][value=?]', '　　　登　　録　　　'
      end
    end
  end

  test 'renders confirmation button' do
    @users.each do |user|
      access_new_post_page(user)
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
      access_new_post_page(user)
      assert_navigation_buttons(user)
    end
  end
end
