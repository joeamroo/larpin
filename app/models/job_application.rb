class JobApplication < ApplicationRecord
  REJECTIONS = [
    "After careful consideration of your application (4 seconds), we have decided to move forward with a candidate who larps harder.",
    "We were blown away by your background. Unfortunately, we were more blown away by someone else's background.",
    "Your application impressed the entire team. We are rejecting you anyway, as a growth opportunity for you.",
    "We've decided to keep the position unfilled to preserve the mystique. Please apply again in 6-8 business years.",
    "Thank you for applying. The role has been given to the founder's nephew, who crushed the vibe check.",
    "You were in our top 1% of applicants. Sadly, we only hire from the top 0%."
  ].freeze

  belongs_to :job, counter_cache: :applications_count
  belongs_to :persona

  validates :persona_id, uniqueness: { scope: :job_id, message: "already rejected once. Know your worth." }

  def rejection
    REJECTIONS[(id || 0) % REJECTIONS.length]
  end
end
