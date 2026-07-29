class ConversationsController < ApplicationController
  def index
    @persona = ensure_persona!
    @conversations = Conversation.involving(@persona).includes(:a, :b, :messages)
                                 .order(Arel.sql("COALESCE(last_message_at, conversations.created_at) DESC"))
  end

  def show
    @persona = ensure_persona!
    @conversation = Conversation.involving(@persona).find(params[:id])
    @conversation.messages.where(read: false).where.not(sender_id: @persona.id).update_all(read: true)
    @messages = @conversation.messages.includes(:sender).order(:created_at)
  end

  def create
    persona = ensure_persona!
    other = Persona.find(params[:persona_id])
    if other.id == persona.id
      redirect_back fallback_location: root_path, alert: "Talking to yourself is called journaling."
    else
      conversation = Conversation.between!(persona, other)
      redirect_to conversation_path(conversation)
    end
  end
end
