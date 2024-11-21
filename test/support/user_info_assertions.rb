module UserInfoAssertions
  def assert_user_info(user)
    user_stat = @user_stats.find { |stat| stat[:user_name] == user.name }

    assert_select 'div#user-info' do
      assert_select 'b', text: "#{user_stat[:user_name]}さんの登録件数：#{user_stat[:post_count]}件"

      total_amount = formatted_total_amount(user_stat[:post_amount])
      assert_select 'b', text: "#{user_stat[:user_name]}さんの合計金額：#{total_amount}"
    end
  end

  private

  def formatted_total_amount(amount)
    number_to_currency(amount, unit: '円', delimiter: ',', format: '%n%u', precision: 0)
  end
end
