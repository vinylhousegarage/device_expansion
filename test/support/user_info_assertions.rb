module UserInfoAssertions
  def assert_user_info(user)
    assert_select 'div#user-info' do
      assert_select 'td', text: "#{user.name}さんの登録件数：#{user.posts.count}件"
      total_amount = formatted_total_amount(user.posts.sum(:amount))
      assert_select 'td', text: "#{user.name}さんの合計金額：#{total_amount}"
    end
  end

  private

  def formatted_total_amount(amount)
    number_to_currency(amount, unit: '円', delimiter: ',', format: '%n%u', precision: 0)
  end
end
