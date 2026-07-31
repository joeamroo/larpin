class Mog < ApplicationRecord
  belongs_to :post, counter_cache: true
  belongs_to :persona

  validates :persona_id, uniqueness: { scope: :post_id }
end
