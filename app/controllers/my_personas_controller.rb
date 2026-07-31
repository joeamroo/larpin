class MyPersonasController < ApplicationController
  def edit
    @persona = ensure_persona!
  end

  def verify
    persona = ensure_persona!
    if persona.can_verify?
      persona.update!(verified: true)
      redirect_to persona_path(persona), notice: "Verified Larper. The blue check means nothing and everything."
    else
      redirect_to persona_path(persona), alert: "You need 100 aura to self-verify. Post, get reactions, mog someone. Earn it."
    end
  end

  # One-click identity reroll for the welcome flow. Keeps posts and connections;
  # replaces the name, headline, and brand color.
  def regenerate
    persona = ensure_persona!
    fresh = PersonaGenerator.generate
    persona.update!(name: fresh[:name], headline: fresh[:headline], hue: fresh[:hue])
    redirect_to root_path(welcome: 1), notice: "Rebranded. You are now #{persona.name}. The old you never existed."
  end

  def update
    @persona = ensure_persona!
    if @persona.update(params.require(:persona).permit(:name, :headline, :bio, :hue, :avatar, :cover, :open_to_larp, :pilled, :coded))
      redirect_to persona_path(@persona), notice: "Rebrand complete. New you, same larp."
    else
      flash.now[:alert] = @persona.errors.full_messages.first
      render :edit, status: :unprocessable_entity
    end
  end
end
