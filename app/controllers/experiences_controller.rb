class ExperiencesController < ApplicationController
  def create
    persona = ensure_persona!
    experience = persona.experiences.new(params.require(:experience).permit(:title, :company, :start_year, :end_year, :description))
    if experience.save
      redirect_to persona_path(persona), notice: "Experience added. Nobody will verify it."
    else
      redirect_to persona_path(persona), alert: experience.errors.full_messages.first
    end
  end

  def destroy
    experience = current_persona&.experiences&.find_by(id: params[:id])
    return head :forbidden unless experience
    experience.destroy
    redirect_to persona_path(current_persona), notice: "Experience removed. It never happened. It never did."
  end
end
