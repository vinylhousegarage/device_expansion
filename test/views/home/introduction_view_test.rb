require 'test_helper'

class HomeIntroductionViewTest < ActionDispatch::IntegrationTest
  test 'should display static text and copyright' do
    get root_path
    assert_response :success

    puts @response.body

    assert_select 'div' do
      assert_select 'p', text: /この度は、「みんなで香典集計」をご覧いただきまして、誠にありがとうございます。/
      assert_select 'p', text: /デモ目的で公開されております。/
      assert_select 'p', text: /実際の使用において発生するいかなる損害や/
      assert_select 'p', text: /Copyright \(c\) 2024 Satoshi Kamazawa/
      assert_select 'a[href="/LICENSE.html"]', text: 'the MIT License'
    end

    assert_select 'form[action=?][method=?]', admin_session_path, 'post' do
      assert_select 'button', text: '　　　スタート　　　'
    end
  end

  test 'should start button for poster user' do
    @user = users(:first_poster)
    get handle_login_qr_code_path(@user)
    assert_response :success
    post sessions_path
    assert_response :success

    get root_path
    assert_response :success

    assert_select 'form[action=?][method=?]', new_post_path, 'get' do
      assert_select 'button', text: '　　　スタート　　　'
    end
  end
end
