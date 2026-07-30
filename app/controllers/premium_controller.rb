class PremiumController < ApplicationController
  def show
    @persona = current_persona
  end

  def activate
    persona = ensure_persona!
    if persona.premium?
      redirect_to premium_path, alert: "You already have Premium. There is nothing above Premium. There is barely Premium."
    else
      persona.update!(premium: true)
      persona.notifications.create!(
        body: "Welcome to LarpIn Premium. Your gold badge is active, Search is unlocked, and nothing else has changed.",
        url: "/premium"
      )
      redirect_to root_path, notice: "Premium activated. The gold badge does nothing, but now it does nothing next to your name. Search unlocked."
    end
  end
end
