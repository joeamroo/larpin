class Conversation < ApplicationRecord
  belongs_to :a, class_name: "Persona"
  belongs_to :b, class_name: "Persona"
  has_many :messages, dependent: :destroy

  scope :involving, ->(p) { where("a_id = :id OR b_id = :id", id: p.id) }

  def self.between!(x, y)
    lo, hi = [x, y].sort_by(&:id)
    find_or_create_by!(a_id: lo.id, b_id: hi.id)
  end

  def other(p)
    a_id == p.id ? b : a
  end

  def unread_count_for(p)
    messages.where(read: false).where.not(sender_id: p.id).count
  end
end
