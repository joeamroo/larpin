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
end
