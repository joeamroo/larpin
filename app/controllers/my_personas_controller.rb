class MyPersonasController < ApplicationController
  def edit
    @persona = ensure_persona!
  end

  def update
    @persona = ensure_persona!
    if @persona.update(params.require(:persona).permit(:name, :headline, :bio, :hue, :avatar, :cover))
      redirect_to persona_path(@persona), notice: "Rebrand complete. New you, same larp."
    else
      flash.now[:alert] = @persona.errors.full_messages.first
      render :edit, status: :unprocessable_entity
    end
  end
end
