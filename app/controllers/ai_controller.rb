class AiController < ApplicationController
  def enhance
    persona = ensure_persona!
    key = "ai_enhance:#{persona.id}"
    count = Rails.cache.increment(key, 1, expires_in: 1.hour)
    return rate_limited!("AI larp budget exhausted. Try writing your own delusions for an hour.") if count && count > 10

    draft = params[:draft].to_s.strip
    return render json: { error: "Write something first. Even a lie needs a first draft." }, status: :unprocessable_entity if draft.blank?

    render json: { text: CringeEnhancer.enhance(draft) }
  end

  def larpmaxx
    persona = ensure_persona!
    # Larpmaxx now costs money when a key is configured, so it needs the same
    # per-persona ceiling the enhance button has. Generous: this is the button
    # people are meant to mash.
    count = Rails.cache.increment("ai_larpmaxx:#{persona.id}", 1, expires_in: 1.hour)
    return rate_limited!("30 larpmaxxes an hour. Even your aura needs a rest.") if count && count > 30

    render json: { text: LarpmaxxGenerator.generate(params[:seed]) }
  end
end
