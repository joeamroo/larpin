class PersonasController < ApplicationController
  def show
    @persona = Persona.find(params[:id])
    @posts = @persona.posts.feed.order(created_at: :desc).limit(30).includes(images_attachments: :blob)
    @experiences = @persona.experiences.ordered
    @skills = @persona.profile_skills.order(:created_at)
    @endorsement_counts = @persona.endorsements.group(:skill).count
  end

  def endorse
    endorser = ensure_persona!
    persona = Persona.find(params[:id])
    skill = persona.profile_skills.find_by(name: params[:skill].to_s)&.name
    return redirect_to persona_path(persona), alert: "That skill isn't on their profile. You can't endorse what they haven't claimed." unless skill
    endorsement = Endorsement.new(persona: persona, endorser: endorser, skill: skill)
    if endorsement.save
      FakeNotifier.real!(persona, actor: endorser,
        body: "#{endorser.name} endorsed you for #{skill}. This is legally binding.",
        url: "/personas/#{persona.id}")
      redirect_to persona_path(persona), notice: "Endorsed for #{skill}."
    else
      redirect_to persona_path(persona), alert: endorsement.errors.full_messages.first
    end
  end
end
