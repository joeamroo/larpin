class SavedPost < ApplicationRecord
  belongs_to :persona
  belongs_to :post

  validates :post_id, uniqueness: { scope: :persona_id }
end
