class Endorsement < ApplicationRecord
  SKILLS = [
    "Thought Leadership", "Delegation", "Standing Near Whiteboards", "Synergy",
    "Disruption", "Vibes", "Stealth Mode", "Personal Branding",
    "Cold Plunges", "Circling Back", "5AM Club", "Firm Handshakes"
  ].freeze

  belongs_to :persona
  belongs_to :endorser, class_name: "Persona"

  validates :skill, inclusion: { in: SKILLS }
  validates :skill, uniqueness: { scope: [:persona_id, :endorser_id] }
  validate :not_self

  private

  def not_self
    errors.add(:base, "self-endorsement detected. Respect.") if persona_id == endorser_id
  end
end
