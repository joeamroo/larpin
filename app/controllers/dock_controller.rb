# The bottom-right chat dock, LinkedIn / old-Facebook style.
#
# Every action here renders ONLY a turbo-frame, with no layout, so the dock can
# poll and swap panels without touching the page behind it. The full-page
# /conversations views are untouched and still work on their own.
class DockController < ApplicationController
  layout false

  # The dock is desktop-only (two 320px panels do not fit a phone), so the global
  # room gets a real page of its own for mobile and for linking to directly.
  def chat_page
    @persona = ensure_persona!
    @messages = GlobalMessage.tail
    render "dock/chat", layout: "application"
  end

  # The list of conversations, shown when the Messaging panel is open.
  def conversations
    @persona = ensure_persona!
    @conversations = Conversation.involving(@persona).includes(:a, :b, :messages)
                                 .order(Arel.sql("COALESCE(last_message_at, conversations.created_at) DESC"))
                                 .limit(20)
    render partial: "dock/conversations", locals: { persona: @persona, conversations: @conversations }
  end

  # One conversation, opened as a chat window inside the dock.
  def conversation
    persona = ensure_persona!
    conversation = Conversation.involving(persona).find(params[:id])
    conversation.messages.where(read: false).where.not(sender_id: persona.id).update_all(read: true)
    messages = conversation.messages.includes(:sender).order(:created_at).last(50)
    render partial: "dock/conversation", locals: { persona: persona, conversation: conversation, messages: messages }
  end

  def global
    persona = ensure_persona!
    render partial: "dock/global", locals: { persona: persona, messages: GlobalMessage.tail }
  end

  def create_global
    persona = ensure_persona!

    count = Rails.cache.increment("global_chat:#{persona.id}", 1, expires_in: 1.minute)
    if count && count > 12
      return render partial: "dock/global",
                    locals: { persona: persona, messages: GlobalMessage.tail,
                              error: "12 messages a minute. Even thought leaders breathe." }
    end

    body = params[:body].to_s.strip.first(500)
    if body.present?
      message = GlobalMessage.create!(persona: persona, body: body)
      GlobalChatter.maybe_reply!(message)
      GlobalMessage.trim! if rand < 0.05
    end

    render partial: "dock/global", locals: { persona: persona, messages: GlobalMessage.tail }
  end
end
