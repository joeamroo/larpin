class CertificationsController < ApplicationController
  def create
    persona = ensure_persona!
    certification = Certification.grant_random!(persona)
    if certification
      persona.notifications.create!(
        body: "Congratulations on completing \"#{certification.course}\" (#{certification.hours}). No exam was administered.",
        url: "/personas/#{persona.id}"
      )
      redirect_to persona_path(persona), notice: "Course completed: #{certification.course}. That was fast."
    else
      redirect_to persona_path(persona), alert: "You have completed every course we pretend to offer. Terrifying."
    end
  end
end
