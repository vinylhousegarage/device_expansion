require 'test_helper'

class PostsEditViewTest < ActionDispatch::IntegrationTest
  test 'should display static text and copyright' do
    get root_path
    assert_response :success

    assert_select 'div' do
      assert_select 'p', text: '本アプリケーションは、デモ目的で公開されております。'
      assert_select 'p', text: 'また、実際の使用において発生するいかなる損害や' +
                        '問題についても責任を負いかねます。'
      assert_select 'p', text: 'Copyright (c) 2024 Satoshi Kamazawa'
      assert_select 'a[href="/LICENSE"]', text: 'the MIT License'
      assert_select 'form[action=?][method=?]', admin_session_path, 'get' do
        assert_select 'button', text: '　　　スタート　　　'
      end
    end
  end

  test 'should start button for poster user' do
    @user = users(:first_poster)
    post login_poster_session_path(@user)
    assert_response :success

    get root_path
    assert_response :success

    assert_select 'form[action=?][method=?]', new_post_path, 'get' do
      assert_select 'button', text: '　　　スタート　　　'
    end
  end
end
