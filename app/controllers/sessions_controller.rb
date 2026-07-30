class SessionsController < ApplicationController
  def new
  end

  def create
    persona = Persona.find_by(email: params[:email].to_s.strip.downcase)
    if persona&.password_digest.present? && persona.authenticate(params[:password].to_s)
      persona.update!(device_token: SecureRandom.hex(32)) if persona.device_token.blank?
      cookies.signed.permanent[:persona_token] = { value: persona.device_token, httponly: true, same_site: :lax }
      redirect_to root_path, notice: "Welcome back, #{persona.name}. The bit missed you."
    else
      flash.now[:alert] = "Wrong email or password. Or you never existed, which is very on-brand here."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    cookies.delete(:persona_token)
    redirect_to root_path, notice: "Signed out. Your persona remains here, larping without you."
  end
end
