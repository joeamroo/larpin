class CommentLike < ApplicationRecord
  belongs_to :comment, counter_cache: :likes_count
  belongs_to :persona

  validates :persona_id, uniqueness: { scope: :comment_id }
end
