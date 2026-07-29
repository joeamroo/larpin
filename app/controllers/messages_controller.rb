class MessagesController < ApplicationController
  BOT_REPLIES = [
    "Love this energy. Let's circle back when the market stabilizes (never).",
    "100%. Adding this to my second brain. My first brain is full.",
    "This is exactly the kind of synergy I DM about. Sending you a calendar link for 4:45 AM.",
    "Incredible. I'm forwarding this to my mastermind group. They're all me on different accounts.",
    "Noted. My assistant (also me) will follow up in 3-5 business identities."
  ].freeze

  def create
    persona = ensure_persona!
    conversation = Conversation.involving(persona).find(params[:conversation_id])
    return rate_limited!("15 messages per minute. Real networkers listen too.") if Message.where(sender_id: persona.id, created_at: 1.minute.ago..).count >= 15

    message = conversation.messages.new(sender: persona, body: params[:message][:body].to_s.strip)
    if message.save
      other = conversation.other(persona)
      if other.is_bot
        conversation.messages.create!(sender: other, body: BOT_REPLIES.sample)
      else
        FakeNotifier.real!(other, actor: persona,
          body: "#{persona.name} sent you a message: \"#{message.body.truncate(50)}\"",
          url: "/conversations/#{conversation.id}")
      end
      redirect_to conversation_path(conversation)
    else
      redirect_to conversation_path(conversation), alert: message.errors.full_messages.first
    end
  end
end
