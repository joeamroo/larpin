# One room, everyone in it. The chat-dock counterpart to the one global feed:
# there are no channels to join and nobody to follow, so whatever you say lands
# in front of the entire site.
class GlobalMessage < ApplicationRecord
  belongs_to :persona

  validates :body, presence: true, length: { maximum: 500 }

  scope :recent, -> { order(created_at: :desc) }

  # The room only ever renders the tail, so the table is trimmed rather than
  # grown forever. This is a joke chat, not an archive.
  KEEP = 300

  def self.trim!
    ids = order(created_at: :desc).offset(KEEP).pluck(:id)
    where(id: ids).delete_all if ids.any?
  end

  def self.tail(limit = 40)
    recent.limit(limit).includes(:persona).to_a.reverse
  end
end
