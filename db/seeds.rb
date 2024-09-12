# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.find_or_create_by(name: "ゲスト１")
User.find_or_create_by(name: "ゲスト２")
User.find_or_create_by(name: "ゲスト３")
User.find_or_create_by(name: "ゲスト４")
User.find_or_create_by(name: "ゲスト５")
User.find_or_create_by(name: "集計担当")
