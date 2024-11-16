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
      assert_field_with_label('氏名', 'post[name]', 'text')
      assert_field_with_label('金額', 'post[amount]', 'number')
      assert_field_with_label('住所', 'post[address]', 'text')
      assert_field_with_label('電話', 'post[tel]', 'text')
      assert_field_with_label('備考', 'post[others]', 'text')
      assert_submit_button('　　　登　　録　　　')
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
