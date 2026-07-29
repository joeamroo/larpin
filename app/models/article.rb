class Article < ApplicationRecord
  belongs_to :persona

  validates :headline, presence: true, length: { maximum: 120 }
  validates :body, length: { maximum: 5000 }

  before_create { self.readers_seed = rand(8..60_000) }

  scope :latest, -> { order(created_at: :desc) }

  def readers
    readers_seed + id.to_i * 7
  end
end
