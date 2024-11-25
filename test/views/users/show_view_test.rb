require 'test_helper'

class UsersShowViewTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper

  def setup
    @user = users(:first_poster)
    @admin_user = users(:admin)
    @users = [@user, @admin_user]
    @mock_user_stats_by_id = mock_user_stats_by_id(@user)
    @mock_all_users_stats = mock_all_users_stats(@user, @admin_user)
  end

  test 'renders user-info section with correct content' do
    @users.each do |user|
      sign_in_as(user)
      get user_path(user)

      assert_user_info(user)
    end
  end

  test 'displays headers in show template for different user roles' do
    sign_in_as(@user)
    get user_path(@user)

    assert_select 'h3', text: "#{@user.name}さんの登録一覧"
    assert_select 'table' do
      assert_select 'th', text: 'No.'
      assert_select 'th', text: '氏名'
      assert_select 'th', text: '金額'
    end
  end

  test 'displays user posts with correct details in show template' do
    sign_in_as(@user)
    get user_path(@user)

    @mock_all_users_stats.each_with_index do |stat, index|
      assert_select 'tr' do
        assert_select 'td', text: (index + 1).to_s
        assert_select 'td', text: stat.user_name
        assert_select 'td', text: "　#{number_with_delimiter(stat.post_amount)} 円　"
        assert_select 'form[action=?][method=?]', post_path(stat.user_id), 'get' do
          assert_select 'button', '詳細'
        end
      end
    end
  end

  test 'displays navigation buttons based on user role in show template' do
    @users.each do |user|
      sign_in_as(user)
      get user_path(user)

      assert_select 'form[action=?][method=?]', new_post_path, 'get' do
        assert_select 'button', '新規登録へ戻る'
      end
      assert_buttons_for_admin if user.name == '集計担当'
    end
  end

  private

  def assert_buttons_for_admin
    assert_select 'form[action=?][method=?]', users_path, 'get' do
      assert_select 'button', '登録状況へ戻る'
    end
    assert_select 'form[action=?][method=?]', new_user_path, 'get' do
      assert_select 'button', '初期画面へ戻る'
    end
  end
end
