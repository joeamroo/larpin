class MessagesController < ApplicationController
  def create
    persona = ensure_persona!
    conversation = Conversation.involving(persona).find(params[:conversation_id])
    return rate_limited!("15 messages per minute. Real networkers listen too.") if Message.where(sender_id: persona.id, created_at: 1.minute.ago..).count >= 15

    message = conversation.messages.new(sender: persona, body: params[:message][:body].to_s.strip)
    if message.save
      other = conversation.other(persona)
      if other.is_bot
        reply = BotReplier.reply_for(conversation: conversation, bot: other,
                                     sender: persona, incoming: message.body)
        conversation.messages.create!(sender: other, body: reply)
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
