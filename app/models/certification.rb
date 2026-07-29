class Certification < ApplicationRecord
  COURSES = [
    { course: "Mastering Synergy", hours: "0.5 hours" },
    { course: "Advanced Circling Back", hours: "2 minutes" },
    { course: "Foundations of Thought Leadership (No Thoughts Required)", hours: "1 hour" },
    { course: "Cold Plunge Theory", hours: "45 seconds" },
    { course: "Negotiation: Saying No to Offers That Don't Exist", hours: "3 hours" },
    { course: "Introduction to Standing Near Whiteboards", hours: "15 minutes" },
    { course: "AI for People Who Say AI a Lot", hours: "6 hours" },
    { course: "Personal Branding for the Personally Unbranded", hours: "1.5 hours" },
    { course: "Boffer Safety Level 1 (the only real course here)", hours: "8 hours" }
  ].freeze

  belongs_to :persona

  validates :course, :hours, presence: true
  validates :course, uniqueness: { scope: :persona_id, message: "already completed. Retaking courses shows weakness." }

  def self.grant_random!(persona)
    remaining = COURSES.reject { |c| persona.certifications.exists?(course: c[:course]) }
    return nil if remaining.empty?
    pick = remaining.sample
    persona.certifications.create!(course: pick[:course], hours: pick[:hours])
  end
end
