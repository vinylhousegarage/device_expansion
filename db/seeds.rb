# 投稿者を定義
POSTER_USERS = %w[投稿者１ 投稿者２ 投稿者３ 投稿者４ 投稿者５].freeze
# 管理者を「集計担当」でとして定義
ADMIN_USERS = %w[集計担当].freeze
# 投稿者と管理者を統合
USERS = (POSTER_USERS + ADMIN_USERS).freeze

# users テーブルの再構成
User.transaction do
  User.where(name: USERS).delete_all

  USERS.each do |user_name|
    User.create!(name: user_name)
  end
end
