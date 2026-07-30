class NetworkController < ApplicationController
  def index
    @persona = ensure_persona!
    @pending = @persona.received_connections.pending.includes(:requester).order(created_at: :desc)
    @accepted = Connection.accepted.involving(@persona).includes(:requester, :receiver).order(updated_at: :desc)
    connected_ids = @accepted.flat_map { |c| [ c.requester_id, c.receiver_id ] } +
                    @pending.map(&:requester_id) +
                    @persona.sent_connections.pluck(:receiver_id) + [ @persona.id ]
    # Real humans first; bots fill the rest.
    @suggestions = Persona.where.not(id: connected_ids.uniq).where.not(name: "LarpIn Premium")
                          .order(Arel.sql("is_bot ASC, RANDOM()")).limit(6)
  end
end
