class Post < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  before_validation :normalize_amount

  def user_post_index
    user.posts.order(:created_at).pluck(:id).index(self.id) + 1
  end

  private

  def normalize_amount
    self.amount = nil if amount.to_s.strip.empty?
  end
end
