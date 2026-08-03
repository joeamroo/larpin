# Summons bot enthusiasm onto a post: 3 bot comments + reactions, once per post.
#
# With a key configured the comments actually respond to what you wrote, which is
# the difference between a bit and a screenshot. One call returns all three, so a
# hype squad costs about the same as a single DM reply.
module HypeSquad
  SYSTEM_PROMPT = <<~PROMPT.freeze
    You write comments on LarpIn, a parody LinkedIn where everyone is openly
    pretending to be a successful professional.

    You will be given a post and the names and headlines of three commenters.
    Write one comment from each, in that order, in character.

    How to be funny here:
    - React to the SPECIFIC content of the post. Quote a detail back. A generic
      "so true king" could sit under anything, which is what makes it dead.
    - Each commenter should reach a different unhinged conclusion. Do not write
      three versions of the same joke.
    - Agreement is always total and always slightly beside the point.
    - Reveal something damning about yourself while praising them.
    - Never break character, never explain the joke.

    Under 22 words each. At most one emoji each, and only if it earns its place.

    Output exactly three lines separated by newlines, one comment per line, in the
    order the commenters were given. No numbering, no names, no quotes, nothing else.
  PROMPT

  HYPE_COMMENTS = [
    "So true, king. 👑",
    "Adding this to my second brain immediately.",
    "This needs to be a TED talk. I would pay $0 to attend.",
    "Absolutely crushing it. Whatever this is.",
    "I felt this in my portfolio.",
    "Printing this out and framing it above my standing desk.",
    "10/10 vulnerability. Very brave. Very monetizable.",
    "Who gave you permission to be this locked in?",
    "Screenshotting this for my vision board.",
    "Based and larppilled.",
    "This is peak larpmaxxing. Study it.",
    "Delulu? Yes. The solulu? Also yes.",
    "Reading this on my treadmill desk. Had to stop. Emotionally.",
    "Sending this to my team. I do not have a team.",
    "This is the kind of thinking that gets you promoted at a company you invented.",
    "I have no notes. I do have an invoice.",
    "Bookmarking this next to my other unread bookmarks.",
    "Every word of this is going in my keynote. Unattributed.",
    "You just described my entire Q3 in one post and I am not okay.",
    "Commenting for reach, but also because this genuinely moved me. Mostly for reach."
  ].freeze

  def self.summon!(post)
    return false if post.hyped?

    bots = Persona.bots.where.not(id: post.persona_id).order("RANDOM()").limit(3).to_a
    return false if bots.empty?

    comments = comments_for(post, bots)
    bots.each_with_index do |bot, i|
      post.comments.create!(persona: bot, body: comments[i])
      Reaction.find_or_create_by!(post: post, persona: bot) { |r| r.kind = Reaction::KINDS.keys.sample }
    end
    post.update!(hyped: true)
    post.persona.add_aura(50)

    post.persona.notifications.create!(
      actor: bots.first,
      body: "Your hype squad has arrived. #{bots.map(&:name).to_sentence} believe in you (contractually).",
      url: "/posts/#{post.id}"
    )
    true
  end

  # Always returns exactly bots.length usable strings, whatever the AI did or did not do.
  def self.comments_for(post, bots)
    generated = ai(post, bots) || []
    canned = HYPE_COMMENTS.sample(bots.length)
    bots.each_index.map { |i| generated[i].presence || canned[i] }
  end

  def self.ai(post, bots)
    return nil if post.body.to_s.strip.blank?

    roster = bots.each_with_index.map { |b, i| "#{i + 1}. #{b.name} (#{b.headline})" }.join("\n")
    context = <<~CTX
      The post, by #{post.persona.name} (#{post.persona.headline}):
      #{post.body.to_s.truncate(800)}

      The three commenters, in order:
      #{roster}
    CTX

    text = Ai::Claude.generate(
      feature: "hype_squad",
      tier: :volume,
      system: SYSTEM_PROMPT,
      user: context,
      max_tokens: 300,
      timeout: 8
    )
    return nil if text.blank?

    text.split("\n")
        .map { |l| unwrap(l.strip.sub(/\A\d+[.)]\s*/, "")) }
        .reject(&:blank?)
        .presence
  end

  # Strip wrapping quotes only when BOTH ends are quoted. Commenters legitimately
  # quote the post back ("Sometimes leadership is just typing" will be my keynote),
  # and blindly dropping a leading quote leaves a dangling one mid-sentence.
  def self.unwrap(line)
    return line[1..-2].to_s.strip if line.length > 2 && line.start_with?('"') && line.end_with?('"')
    line
  end
end
