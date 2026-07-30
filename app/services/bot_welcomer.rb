# When a new persona is minted, bots immediately make them feel popular:
# a few pending connection requests and one welcome DM.
module BotWelcomer
  WELCOME_DMS = [
    "Hey! Huge fan of your work (I have not seen your work). I'd love to add you to my professional network and also pitch you something in 2-4 business days.",
    "I never send cold DMs, so consider yourself warm. Quick question: are you open to 10x-ing everything? No reason.",
    "Saw your profile and immediately thought: synergy. Coffee chat? I only do 4:45 AM slots.",
    "Welcome to LarpIn. Everything here is fake except the connections, which are also fake. You're going to do great things.",
    "Quick vibe check: are you larpmaxxing or just larping? There are no wrong answers, only wrong people."
  ].freeze

  def self.welcome!(persona)
    bots = Persona.bots.order("RANDOM()").limit(4).to_a
    return if bots.empty?

    bots.first(3).each do |bot|
      Connection.find_or_create_by!(requester: bot, receiver: persona)
    rescue ActiveRecord::RecordInvalid
      nil
    end

    dm_bot = bots.last
    convo = Conversation.between!(dm_bot, persona)
    convo.messages.create!(sender: dm_bot, body: WELCOME_DMS.sample) if convo.messages.none?

    persona.notifications.create!(
      body: "Welcome to LarpIn. Your personal brand is already being perceived.",
      url: "/network"
    )
  end
end
