# The "You need to be X-maxxing" snowclone, straight from the meme format:
# imperative opener, escalating absurd concrete instructions, restate the maxx.
#
# Two paths. Claude writes it when a key is configured, because the joke lives or
# dies on the instructions being specific to YOUR word. The template path below
# runs otherwise, and it is deliberately large: this is the button people press
# five times in a row, so a small phrase pool gets caught immediately.
module LarpmaxxGenerator
  SEEDS = %w[synergy grindset stealth founder hustle aura discipline delusion
             networking vulnerability keynote fasting pivoting manifesting
             thoughtleader burnout runway pipeline mindset optionality].freeze

  SYSTEM_PROMPT = <<~PROMPT.freeze
    You write posts in the "-maxxing" meme format for LarpIn, a parody LinkedIn.

    The format, exactly:
    Line 1: "You need to be <word>maxxing."
    Then 3 lines, each starting "You need to be ", each a SPECIFIC absurd action a
    LinkedIn poster would actually brag about. Escalate: the third is the unhinged one.
    Then: "Stop being an NPC. Start <word>maxxing."
    Then one line of 2 to 4 hashtags.

    What makes it funny instead of generic:
    - Concrete nouns beat abstract ones. "NDA-ing your barista" lands, "maximizing
      your potential" does not. Name real objects, times, places, job titles.
    - Never explain the joke and never wink at it. Total sincerity is the bit.
    - No line may be a generic motivational platitude.
    - Keep every line under 15 words.

    Return ONLY the post text. No preamble, no quotes around it.
  PROMPT

  INSTRUCTIONS = {
    "synergy" => [ "circling back on emails you never sent", "double-clicking on ideas that don't exist",
                  "aligning stakeholders who have never met you", "leveraging synergies in the shower",
                  "taking things offline that were never online" ],
    "grindset" => [ "waking up at 3:47 AM for no reason", "cold plunging in your neighbor's pool",
                   "journaling about the journaling", "replying to your own posts to boost engagement",
                   "counting your commute as cardio and your cardio as thinking" ],
    "stealth" => [ "telling everyone you're in stealth", "raising a round for an idea you haven't had",
                  "NDA-ing your barista", "posting exclusively in vague hints",
                  "declining to confirm or deny your own employment status" ],
    "founder" => [ "adding CEO to a company that is one Notes app entry", "wearing the same shirt as a personality",
                  "calling your unemployment a sabbatical", "pitching to a mirror until it invests",
                  "describing your roommate as an early operator" ],
    "hustle" => [ "monetizing your commute", "invoicing your own hobbies",
                 "treating sleep as a churn problem", "scheduling a 5 AM sync with yourself" ],
    "aura" => [ "not replying for four business days on purpose", "leaving rooms before anyone asks what you do",
               "answering questions with a longer question", "keeping your camera off in a one-on-one" ],
    "networking" => [ "adding people you have made eye contact with", "congratulating strangers on work anniversaries",
                     "showing up to a conference you are not attending", "calling a coffee a strategic touchpoint" ],
    "vulnerability" => [ "crying in a way that photographs well", "posting your rejection emails for reach",
                        "sharing a struggle you have already monetized", "opening with 'I wasn't going to share this'" ],
    "default" => [ "locking in at hours no human should be awake", "manufacturing a personality out of one habit",
                  "invoicing people who asked you a question", "screenshotting your own wins for the vision board",
                  "referring to your problems as learnings", "narrating your life like a LinkedIn carousel",
                  "putting a whiteboard behind you for credibility", "describing a nap as a recovery block",
                  "treating your calendar as a personality", "hiring an intern who is also you",
                  "quoting yourself with attribution", "putting 'building something' in your bio indefinitely",
                  "calling your group chat an advisory board", "measuring friendships in touchpoints" ]
  }.freeze

  HASHTAG_POOL = %w[Larpmaxxing Aura Grindset Delulu NPCBehavior LockedIn Mindset
                    BuildingInPublic NoDaysOff MainCharacter ThoughtLeadership].freeze

  def self.generate(seed = nil)
    word = normalize(seed)
    ai(word) || fallback(word)
  end

  def self.normalize(seed)
    raw = seed.to_s.strip.downcase.gsub(/[^a-z0-9 ]/, "").split.first
    return SEEDS.sample if raw.blank?
    # "stealthmaxxing" typed into the box should not come back "stealthmaxxingmaxxing".
    raw.sub(/maxx(ing)?\z/, "").presence&.first(24) || SEEDS.sample
  end

  def self.ai(word)
    Ai::Claude.generate(
      feature: "larpmaxx",
      tier: :showcase,
      system: SYSTEM_PROMPT,
      user: "The word is: #{word}",
      max_tokens: 1200, # headroom for adaptive thinking, see Ai::Claude::MODELS
      timeout: 18
    )
  end

  def self.fallback(word)
    pool = (INSTRUCTIONS[word] || []) + INSTRUCTIONS["default"]
    lines = pool.uniq.sample(3)
    tags = HASHTAG_POOL.sample(2).map { |t| "##{t}" }.join(" ")
    <<~POST.strip
      You need to be #{word}maxxing.

      You need to be #{lines[0]}.
      You need to be #{lines[1]}.
      You need to be #{lines[2]}.

      Stop being an NPC. Start #{word}maxxing.

      Agree? 👇 ##{word.capitalize}maxxing #{tags}
    POST
  end
end
