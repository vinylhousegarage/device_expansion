# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# 投稿者を定義
POSTER_USERS = %w[ゲスト１ ゲスト２ ゲスト３ ゲスト４ ゲスト５].freeze

# 管理者を定義
ADMIN_USERS = %w[集計担当].freeze

# ユーザーのリストを統合
USERS = (POSTER_USERS + ADMIN_USERS).freeze

# データベースと自動インクリメントのリセット
User.destroy_all
%w[users posts].each do |table_name|
  ActiveRecord::Base.connection.execute("ALTER SEQUENCE #{table_name}_id_seq RESTART WITH 1")
end

# 初期データを作成
USERS.each do |user_name|
  User.create!(name: user_name)
end
