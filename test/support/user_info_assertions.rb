module UserInfoAssertions
  def assert_user_info(user)
    assert_select 'div#user-info' do
      assert_select 'b', text: "#{user.name}さんの登録件数：#{user.posts.count}件"
      assert_select 'b', text: "#{user.name}さんの合計金額：#{number_to_currency(user.posts.sum(:amount), unit: '円', delimiter: ',', format: '%n%u', precision: 0)}"
    end
  end
end
