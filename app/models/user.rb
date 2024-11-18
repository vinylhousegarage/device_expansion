class User < ApplicationRecord
  include Rails.application.routes.url_helpers
  has_many :posts, dependent: :destroy

  # 管理者を「集計担当」として定義
  ADMIN_USERS = ['集計担当'].freeze
  # 管理者をデータベースから取得するスコープを定義
  scope :admin_users, -> { where(name: ADMIN_USERS) }

  # 投稿者を定義
  POSTER_USERS = %w[投稿者１ 投稿者２ 投稿者３ 投稿者４ 投稿者５].freeze
  # 投稿者をデータベースから取得するスコープを定義
  scope :poster_users, -> { where(name: POSTER_USERS) }

  # すべてのユーザーを定義
  USERS = %w[投稿者１ 投稿者２ 投稿者３ 投稿者４ 投稿者５ 集計担当].freeze
  # すべてのユーザーをデータベースから取得するスコープを定義
  scope :users, -> { where(name: USERS) }
end
