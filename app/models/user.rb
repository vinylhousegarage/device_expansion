class User < ApplicationRecord
  has_many :posts

  # 投稿者を定義
  GUEST_NAMES = ['ゲスト１', 'ゲスト２', 'ゲスト３', 'ゲスト４', 'ゲスト５'].freeze
end
