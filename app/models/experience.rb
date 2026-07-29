class Experience < ApplicationRecord
  belongs_to :persona

  validates :title, :company, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :start_year, numericality: { in: 1900..2100 }
  validates :end_year, numericality: { in: 1900..2100 }, allow_nil: true
  validate :years_in_order

  scope :ordered, -> { order(Arel.sql("end_year IS NOT NULL"), end_year: :desc, start_year: :desc) }

  def years_label
    "#{start_year} - #{end_year || 'Present'}"
  end

  def duration_label
    years = (end_year || Date.current.year) - start_year
    years <= 0 ? "less than a year (felt longer)" : "#{years} yr#{'s' if years > 1}"
  end

  private

  def years_in_order
    return if end_year.nil? || start_year.nil?
    errors.add(:end_year, "can't end before it began. Even fake jobs obey time.") if end_year < start_year
  end
end
