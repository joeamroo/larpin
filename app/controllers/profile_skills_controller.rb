class ProfileSkillsController < ApplicationController
  def create
    persona = ensure_persona!
    skill = persona.profile_skills.new(name: params.require(:profile_skill)[:name].to_s.strip)
    if skill.save
      redirect_to persona_path(persona), notice: "Skill claimed. Endorsements pending."
    else
      redirect_to persona_path(persona), alert: skill.errors.full_messages.first
    end
  end

  def destroy
    skill = current_persona&.profile_skills&.find_by(id: params[:id])
    return head :forbidden unless skill
    skill.destroy
    redirect_to persona_path(current_persona), notice: "Skill removed from the record."
  end
end
