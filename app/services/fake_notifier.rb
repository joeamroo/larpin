# Generates the absurd fake notifications that make LarpIn feel alive.
module FakeNotifier
  VIEWERS = [
    "3 VCs and a hiring manager at Blackstone",
    "someone who typed 'per my last email' and deleted it",
    "a Fortune 500 CEO (unverified)",
    "2 recruiters, 1 rival, and your old boss",
    "an anonymous LinkedIn Top Voice",
    "the algorithm itself. It felt something.",
    "14 people in Stealth Mode",
    "a podcast host looking for guests exactly like you"
  ].freeze

  # For each of the persona's posts older than 2 minutes that doesn't yet have
  # a fake "viewed by" notification, create one. Idempotent per post via url tag.
  def self.backfill!(persona)
    persona.posts.where(created_at: ..2.minutes.ago).limit(20).find_each do |post|
      tag = "/posts/#{post.id}#fake"
      next if persona.notifications.exists?(url: tag)
      persona.notifications.create!(
        body: "Your post was viewed by #{VIEWERS.sample}.",
        url: tag
      )
    end
  end

  def self.real!(persona, actor:, body:, url:)
    return if persona.id == actor&.id
    persona.notifications.create!(actor: actor, body: body, url: url)
  end
end
