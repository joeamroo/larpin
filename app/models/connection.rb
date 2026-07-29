class Connection < ApplicationRecord
  belongs_to :requester, class_name: "Persona"
  belongs_to :receiver, class_name: "Persona"

  validates :status, inclusion: { in: %w[pending accepted] }
  validates :requester_id, uniqueness: { scope: :receiver_id }
  validate :not_self

  scope :accepted, -> { where(status: "accepted") }
  scope :pending, -> { where(status: "pending") }
  scope :involving, ->(p) { where("requester_id = :id OR receiver_id = :id", id: p.id) }
  scope :between, ->(a, b) {
    where(requester_id: a.id, receiver_id: b.id).or(where(requester_id: b.id, receiver_id: a.id))
  }

  def other(p)
    requester_id == p.id ? receiver : requester
  end

  private

  def not_self
    errors.add(:base, "networking with yourself is a v2 feature") if requester_id == receiver_id
  end
end
