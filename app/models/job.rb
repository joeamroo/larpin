class Job < ApplicationRecord
  belongs_to :persona
  has_many :job_applications, dependent: :destroy

  validates :title, :company, presence: true, length: { maximum: 120 }
  validates :location, :comp, length: { maximum: 120 }
  validates :description, length: { maximum: 3000 }

  def applied_by?(p)
    p && job_applications.exists?(persona_id: p.id)
  end
end
