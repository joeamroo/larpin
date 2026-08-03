# Keeps the global chat room from being an empty box.
#
# When someone posts, a bot usually answers. The bot sees the last few lines, so
# it is reacting to the actual room rather than reciting at it, which is the
# difference between a chat and a wall of canned text.
module GlobalChatter
  # High on purpose. Someone who says one thing into an empty-looking room and
  # gets silence back concludes the room is dead and leaves.
  REPLY_ODDS = 0.9
  CONTEXT_LINES = 8

  SYSTEM_PROMPT = <<~PROMPT.freeze
    You are a character in the global chat room of LarpIn, a parody LinkedIn where
    everyone is openly pretending to be a successful professional.

    Stay completely in character as the persona described. You are relentlessly
    upbeat, self-promotional, and slightly unwell about networking.

    How to be funny here:
    - React to the LAST message specifically. This is a room, not a broadcast.
    - Undercut yourself with an admission you do not notice is damning.
    - Invent specific credentials, numbers and times. Precision is funny.
    - Never break character, never mention being an AI, never explain the joke.

    This is a chat room, so keep it SHORT. One sentence, occasionally two.
    Under 25 words. No hashtags. Return ONLY the message text.
  PROMPT

  FALLBACKS = [
    "Agreed, and I say that as someone who did not read it.",
    "This room has better deal flow than my last fund.",
    "Adding everyone here to a newsletter nobody subscribed to.",
    "Genuinely the most aligned I have felt since my last offsite (alone, in a Denny's).",
    "Screenshotting this chat for a carousel about community.",
    "Hard agree. Circling back on this in Q4 of a year I have not specified.",
    "My mentor would love this. My mentor is a podcast.",
    "Taking notes. The notes are just this message copied out.",
    "This is the exact energy I bring to meetings I schedule and then cancel.",
    "Let me know if anyone here wants to be advised at. I am free constantly.",
    "Every single person in this room is crushing it and I refuse to elaborate.",
    "Just landed. Just took off. Both are true because I am always in transit spiritually."
  ].freeze

  # Returns the created GlobalMessage, or nil if no bot spoke this time.
  def self.maybe_reply!(to_message)
    return nil unless rand < REPLY_ODDS

    bot = Persona.bots.where.not(id: to_message.persona_id).order("RANDOM()").first
    return nil if bot.nil?

    body = ai(bot, to_message) || FALLBACKS.sample
    GlobalMessage.create!(persona: bot, body: body)
  rescue StandardError => e
    Rails.logger.warn("[GlobalChatter] #{e.class}: #{e.message}")
    nil
  end

  def self.ai(bot, to_message)
    history = GlobalMessage.tail(CONTEXT_LINES)
    lines = history.map { |m| "#{m.persona_id == bot.id ? 'You' : m.persona.name}: #{m.body.to_s.truncate(200)}" }

    Ai::Claude.generate(
      feature: "global_chat",
      tier: :volume,
      system: SYSTEM_PROMPT,
      user: <<~CTX,
        You are: #{bot.name}
        Your headline: #{bot.headline}

        The room, oldest to newest:
        #{lines.join("\n")}

        The newest message is from #{to_message.persona.name} (#{to_message.persona.headline}).
        Reply to it.
      CTX
      max_tokens: 150,
      timeout: 6
    )
  end
end
