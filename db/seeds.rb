# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# 投稿者を定義
POSTER_USERS = %w[投稿者１ 投稿者２ 投稿者３ 投稿者４ 投稿者５].freeze
# 管理者を「集計担当」名で定義
ADMIN_USERS = %w[集計担当].freeze
# 投稿者と管理者を統合
USERS = (POSTER_USERS + ADMIN_USERS).freeze

# find_or_create_byを使用してユーザーを作成
USERS.each do |user_name|
  User.find_or_create_by(name: user_name)
end
