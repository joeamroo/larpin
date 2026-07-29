class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes
  helper_method :current_persona

  private

  def current_persona
    return @current_persona if defined?(@current_persona)
    token = cookies.signed[:persona_token]
    @current_persona = token && Persona.find_by(device_token: token)
  end

  # Mint a persona on first visit/participation.
  def ensure_persona!
    return current_persona if current_persona
    token = SecureRandom.hex(32)
    persona = Persona.create!(PersonaGenerator.generate.merge(device_token: token))
    cookies.signed.permanent[:persona_token] = { value: token, httponly: true, same_site: :lax }
    BotWelcomer.welcome!(persona)
    @current_persona = persona
  end

  def rate_limited!(message = "Slow down. Even larps need pacing.")
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, alert: message }
      format.turbo_stream do
        flash.now[:alert] = message
        render turbo_stream: turbo_stream.update("flashes", partial: "shared/flashes"), status: :too_many_requests
      end
      format.json { render json: { error: message }, status: :too_many_requests }
    end
  end
end
