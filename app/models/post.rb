class Post < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  scope :by_user, ->(user_id) { where(user_id:) }
end
