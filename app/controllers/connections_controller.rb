class ConnectionsController < ApplicationController
  def create
    persona = ensure_persona!
    receiver = Persona.find(params[:receiver_id])
    connection = Connection.new(requester: persona, receiver: receiver)
    if Connection.between(persona, receiver).exists?
      redirect_back fallback_location: network_path, alert: "Connection already in flight."
    elsif connection.save
      # Bots always say yes. That's what makes them bots.
      if receiver.is_bot
        connection.update!(status: "accepted")
        FakeNotifier.real!(persona, actor: receiver,
          body: "#{receiver.name} accepted your connection request. You're basically partners now.",
          url: "/network")
      end
      redirect_back fallback_location: network_path, notice: receiver.is_bot ? "Connected instantly. Bots don't play hard to get." : "Request sent."
    else
      redirect_back fallback_location: network_path, alert: connection.errors.full_messages.first
    end
  end

  def update
    persona = ensure_persona!
    connection = persona.received_connections.pending.find(params[:id])
    connection.update!(status: "accepted")
    FakeNotifier.real!(connection.requester, actor: persona,
      body: "#{persona.name} accepted your connection request.",
      url: "/network")
    redirect_back fallback_location: network_path, notice: "Connected. Your networks are now synergized."
  end
end
