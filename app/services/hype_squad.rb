# Summons bot enthusiasm onto a post: 3 bot comments + reactions, once per post.
module HypeSquad
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
    "Delulu? Yes. The solulu? Also yes."
  ].freeze

  def self.summon!(post)
    return false if post.hyped?

    bots = Persona.bots.where.not(id: post.persona_id).order("RANDOM()").limit(3).to_a
    return false if bots.empty?

    comments = HYPE_COMMENTS.sample(3)
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
end
