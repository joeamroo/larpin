class ProfileSkill < ApplicationRecord
  MAX_PER_PERSONA = 15

  belongs_to :persona

  validates :name, presence: true, length: { maximum: 40 }
  validates :name, uniqueness: { scope: :persona_id, case_sensitive: false, message: "is already on your profile. One larp per skill." }
  validate :under_limit, on: :create

  def endorsement_count
    persona.endorsements.where(skill: name).count
  end

  private

  def under_limit
    if persona && persona.profile_skills.count >= MAX_PER_PERSONA
      errors.add(:base, "#{MAX_PER_PERSONA} skills maximum. Nobody believes more than that anyway.")
    end
  end
end
