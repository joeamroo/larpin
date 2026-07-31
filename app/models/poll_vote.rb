class PollVote < ApplicationRecord
  belongs_to :post
  belongs_to :persona

  validates :persona_id, uniqueness: { scope: :post_id }
  validate :valid_choice

  private

  def valid_choice
    errors.add(:choice, "is not on the ballot") unless post && choice&.between?(0, Array(post.poll_options).size - 1)
  end
end
