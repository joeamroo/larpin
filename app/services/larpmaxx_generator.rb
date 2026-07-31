# The "You need to be X-maxxing" snowclone, straight from the meme format:
# imperative opener, escalating absurd concrete instructions, restate the maxx.
module LarpmaxxGenerator
  SEEDS = %w[synergy grindset stealth founder hustle aura discipline delusion
             networking vulnerability keynote fasting pivoting manifesting].freeze

  INSTRUCTIONS = {
    "synergy" => [ "circling back on emails you never sent", "double-clicking on ideas that don't exist",
                  "aligning stakeholders who have never met you", "leveraging synergies in the shower" ],
    "grindset" => [ "waking up at 3:47 AM for no reason", "cold plunging in your neighbor's pool",
                   "journaling about the journaling", "replying to your own posts to boost engagement" ],
    "stealth" => [ "telling everyone you're in stealth", "raising a round for an idea you haven't had",
                  "NDA-ing your barista", "posting exclusively in vague hints" ],
    "founder" => [ "adding CEO to a company that is one Notes app entry", "wearing the same shirt as a personality",
                  "calling your unemployment a sabbatical", "pitching to a mirror until it invests" ],
    "default" => [ "locking in at hours no human should be awake", "manufacturing a personality out of one habit",
                  "invoicing people who asked you a question", "screenshotting your own wins for the vision board",
                  "referring to your problems as learnings", "narrating your life like a LinkedIn carousel" ]
  }.freeze

  def self.generate(seed = nil)
    word = seed.to_s.strip.downcase.split.first.presence || SEEDS.sample
    key = INSTRUCTIONS.key?(word) ? word : "default"
    lines = (INSTRUCTIONS[key] + INSTRUCTIONS["default"]).uniq.sample(3)
    <<~POST.strip
      You need to be #{word}maxxing.

      You need to be #{lines[0]}.
      You need to be #{lines[1]}.
      You need to be #{lines[2]}.

      Stop being an NPC. Start #{word}maxxing.

      Agree? 👇 ##{word.capitalize}maxxing #Larpmaxxing #Aura
    POST
  end
end
