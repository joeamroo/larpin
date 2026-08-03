# The bot on the other end of a DM.
#
# This is the feature the launch copy leads with ("DM anyone, the bots reply
# instantly"), so a canned rotation of five lines is the fastest way to get
# caught. With a key configured the bot answers IN CHARACTER and actually
# responds to what you said, staying oblivious the entire time.
#
# Runs inline in the request because the reply has to exist by the time the
# redirect renders. That is what makes it feel instant, and it is why the
# timeout here is short and the fallback is always ready.
module BotReplier
  CONTEXT_MESSAGES = 6

  SYSTEM_PROMPT = <<~PROMPT.freeze
    You are a character on LarpIn, a parody LinkedIn where everyone is openly
    pretending to be a successful professional. You are replying to a DM.

    Stay completely in character as the persona described in the user message.
    You are relentlessly upbeat, self-promotional, and slightly unwell about
    networking. You treat every message as an opportunity.

    How to be funny here:
    - Actually respond to what they said. Reference their specific words, then
      misread them as a business opportunity. Ignoring their message is the
      lazy version of this joke.
    - Undercut yourself with an admission you do not notice is damning.
      ("My mastermind group loves this. They're all me on different accounts.")
    - Invent specific credentials, metrics, and calendar times. Precision is funny.
    - Never break character, never acknowledge being an AI or a bot, never
      apologize, never explain the joke.

    One to three sentences. Under 45 words. No hashtags. No emoji unless it is
    doing real work. Return ONLY the reply text.
  PROMPT

  FALLBACKS = [
    "Love this energy. Let's circle back when the market stabilizes (never).",
    "100%. Adding this to my second brain. My first brain is full.",
    "This is exactly the kind of synergy I DM about. Sending you a calendar link for 4:45 AM.",
    "Incredible. I'm forwarding this to my mastermind group. They're all me on different accounts.",
    "Noted. My assistant (also me) will follow up in 3-5 business identities.",
    "Saying yes before I've read it. That's founder mode.",
    "I'm going to be honest with you, which is my brand: I skimmed. But I'm in.",
    "This aligns with my Q3 thesis, which I wrote this morning, about this.",
    "Let me loop in my co-founder. He's a mirror I talk to. He also says yes.",
    "Screenshotting this for a carousel about people who message me.",
    "Big if true. Bigger if false and I post about it anyway.",
    "You had me at the first word, which I'm told was 'hey'.",
    "I don't take cold DMs, so I'm reclassifying this one as warm. Congratulations.",
    "Adding you to my network, my newsletter, and a slide about traction.",
    "Genuinely inspiring. I'm going to repost this as an original thought."
  ].freeze

  def self.reply_for(conversation:, bot:, sender:, incoming:)
    ai(conversation: conversation, bot: bot, sender: sender, incoming: incoming) || FALLBACKS.sample
  end

  def self.ai(conversation:, bot:, sender:, incoming:)
    Ai::Claude.generate(
      feature: "bot_dm",
      tier: :volume,
      system: SYSTEM_PROMPT,
      user: context(conversation: conversation, bot: bot, sender: sender, incoming: incoming),
      max_tokens: 200,
      timeout: 6
    )
  end

  def self.context(conversation:, bot:, sender:, incoming:)
    history = conversation.messages.order(created_at: :desc).limit(CONTEXT_MESSAGES).to_a.reverse
    lines = history.map do |m|
      who = m.sender_id == bot.id ? "You" : sender.name
      "#{who}: #{m.body.to_s.truncate(300)}"
    end

    <<~CTX
      You are: #{bot.name}
      Your headline: #{bot.headline}
      #{"Your bio: #{bot.bio.to_s.truncate(200)}" if bot.bio.present?}

      You are DMing with: #{sender.name} (#{sender.headline})

      Conversation so far:
      #{lines.join("\n")}

      Their newest message: #{incoming.to_s.truncate(500)}

      Write your reply.
    CTX
  end
end
