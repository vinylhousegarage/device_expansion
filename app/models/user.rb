class User < ApplicationRecord
  has_many :posts

  # 投稿者を定義
  POSTER_USERS = ['投稿者１', '投稿者２', '投稿者３', '投稿者４', '投稿者５'].freeze
  # 投稿者をデータベースから取得するスコープを定義
  scope :poster_users, -> { where(name: POSTER_USERS) }
end
