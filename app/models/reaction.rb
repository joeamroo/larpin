class Reaction < ApplicationRecord
  KINDS = {
    "grindset"     => { emoji: "😤", label: "Grindset" },
    "labubu"       => { emoji: "🧸", label: "Labubu" },
    "larp_sahur"   => { emoji: "🪵", label: "Larp Larp Larp Sahur" },
    "aura_farming" => { emoji: "🕴", label: "Aura Farming" }
  }.freeze

  belongs_to :post, counter_cache: true
  belongs_to :persona

  validates :kind, inclusion: { in: KINDS.keys }
  validates :persona_id, uniqueness: { scope: :post_id }
end
