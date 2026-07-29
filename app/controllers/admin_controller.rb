class AdminController < ApplicationController
  skip_forgery_protection
  before_action :require_admin_token!

  def destroy_post
    Post.find(params[:id]).destroy
    head :no_content
  end

  def destroy_persona
    persona = Persona.find(params[:id])
    head :unprocessable_entity and return if persona.is_bot
    persona.destroy
    head :no_content
  end

  private

  def require_admin_token!
    token = ENV["ADMIN_TOKEN"]
    head :not_found unless token.present? && ActiveSupport::SecurityUtils.secure_compare(params[:token].to_s, token)
  end
end
