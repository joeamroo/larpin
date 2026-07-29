class PersonasController < ApplicationController
  def show
    @persona = Persona.find(params[:id])
    @posts = @persona.posts.feed.order(created_at: :desc).limit(30).includes(images_attachments: :blob)
  end

  def endorse
    endorser = ensure_persona!
    persona = Persona.find(params[:id])
    skill = params[:skill].presence_in(Endorsement::SKILLS) || Endorsement::SKILLS.sample
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
