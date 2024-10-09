class User < ApplicationRecord
  has_many :posts

  # 投稿者をIDと名前で定義
  GUEST_USERS = {
    1 => 'ゲスト１',
    2 => 'ゲスト２',
    3 => 'ゲスト３',
    4 => 'ゲスト４',
    5 => 'ゲスト５'
  }.freeze
end
