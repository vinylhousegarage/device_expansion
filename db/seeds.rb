# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

USERS = %w[ゲスト１ ゲスト２ ゲスト３ ゲスト４ ゲスト５ 集計担当].freeze

USERS.each do |user_name|
  User.find_or_create_by(name: user_name)
end
