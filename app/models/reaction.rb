class Reaction < ApplicationRecord
  KINDS = {
    "inspiring"  => { emoji: "🚀", label: "Inspiring" },
    "congrats"   => { emoji: "👏", label: "Congrats" },
    "insightful" => { emoji: "💡", label: "Insightful" },
    "grindset"   => { emoji: "😤", label: "Grindset" },
    "cap"        => { emoji: "🧢", label: "Cap" },
    "gym"        => { emoji: "😭", label: "Crying at the Gym" }
  }.freeze

  belongs_to :post, counter_cache: true
  belongs_to :persona

  validates :kind, inclusion: { in: KINDS.keys }
  validates :persona_id, uniqueness: { scope: :post_id }
end
