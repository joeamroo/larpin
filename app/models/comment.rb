class Comment < ApplicationRecord
  belongs_to :post, counter_cache: true
  belongs_to :persona
  has_many :comment_likes, dependent: :destroy

  validates :body, presence: true, length: { maximum: 1500 }

  def liked_by?(p)
    p && comment_likes.exists?(persona_id: p.id)
  end
end
