class Post < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  before_validation :normalize_amount

  private

  def normalize_amount
    self.amount = nil if amount.to_s.strip.empty?
  end

  scope :by_user, ->(user_id) { where(user_id:) }
end
