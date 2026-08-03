# Rewrites a draft into maximum professional cringe. Uses Claude when
# ANTHROPIC_API_KEY is set; otherwise a deterministic template fallback so the
# button works with zero configuration.
module CringeEnhancer
  SYSTEM_PROMPT = <<~PROMPT.freeze
    You rewrite text into a parody of the most insufferable LinkedIn hustle-culture post imaginable.

    Keep the user's core topic recognizable. That is the whole joke: their actual
    mundane thing, delivered like a TED talk.

    Structure: a dramatic one-line hook, then short punchy lines with hard line
    breaks, unnecessary vulnerability, at least one humble-brag, at least one
    invented metric with a suspiciously precise number, a numbered list of
    "lessons", then a question to drive engagement and 3 to 5 absurd hashtags.
    Emojis as bullet points.

    Sprinkle one or two pieces of current internet slang where they actually land
    (larpmaxxing, delulu, aura, NPC, locked in, main character). One or two. A
    post stuffed with slang reads as a bot, not a poster.

    Never wink at the reader and never explain the joke. Total sincerity is the bit.
    Under 150 words. Return ONLY the rewritten post text.
  PROMPT

  HOOKS = [
    "I wasn't going to share this. But my mentor said the world needs it.",
    "3 years ago I was sleeping on an air mattress. Today, everything changed.",
    "A recruiter just called me crying. Here's why.",
    "This morning at 4:02 AM, my cold plunge taught me something about B2B sales.",
    "I got rejected 47 times last week. I've never felt more alive."
  ].freeze

  LESSONS = [
    "Your network is your net worth.",
    "Sleep is a subscription you can cancel.",
    "Comfort zones are where dreams go to die.",
    "If you're the smartest person in the room, invoice the room.",
    "Discipline is just self-love wearing a suit.",
    "Delulu is the solulu, especially in B2B.",
    "NPCs network. Main characters larpmaxx."
  ].freeze

  CLOSERS = [
    "Agree? 👇", "Thoughts? 👇", "Who else is locked in? 👇",
    "Repost if this resonated. My team reads every share.", "Follow for more raw truths."
  ].freeze

  HASHTAGS = %w[#Grindset #Blessed #ThoughtLeadership #5AMClub #Hustle #Synergy
                #BuildingInPublic #Larpmaxxing #NoDaysOff #Mindset #Delulu #AuraFarming].freeze

  def self.enhance(text)
    ai(text) || fallback(text)
  end

  def self.ai(text)
    Ai::Claude.generate(
      feature: "cringe_enhance",
      tier: :showcase,
      system: SYSTEM_PROMPT,
      user: text.to_s.first(2000),
      max_tokens: 1600, # headroom for adaptive thinking, see Ai::Claude::MODELS
      timeout: 20
    )
  end

  def self.fallback(text)
    seed = text.to_s.sum
    core = text.to_s.strip.first(400)
    lessons = LESSONS.shuffle(random: Random.new(seed)).first(3)
    <<~POST.strip
      #{HOOKS[seed % HOOKS.length]}

      #{core}

      Let that sink in.

      What this taught me:
      #{lessons.each_with_index.map { |l, i| "#{i + 1}. #{l}" }.join("\n")}

      #{CLOSERS[seed % CLOSERS.length]}

      #{HASHTAGS.shuffle(random: Random.new(seed)).first(4).join(" ")}
    POST
  end
end
