class User < ApplicationRecord
  include Rails.application.routes.url_helpers
  has_many :posts, dependent: :destroy

  # 投稿者を「ゲスト」として定義
  POSTER_USERS = %w[ゲスト１ ゲスト２ ゲスト３ ゲスト４ ゲスト５].freeze
  # 管理者を「集計担当」として定義
  ADMIN_USERS = %w[集計担当].freeze
  # すべてのユーザーを定義
  USERS = (POSTER_USERS + ADMIN_USERS).freeze

  # 投稿者をデータベースから取得するスコープを定義
  scope :poster_users, -> { where(name: POSTER_USERS) }
  # 管理者をデータベースから取得するスコープを定義
  scope :admin_users, -> { where(name: ADMIN_USERS) }
  # すべてのユーザーをデータベースから取得するスコープを定義
  scope :users, -> { where(name: USERS) }

  # 管理者を判定
  def admin?
    User::ADMIN_USERS.include?(name)
  end
end
