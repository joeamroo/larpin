class LarpboardController < ApplicationController
  def index
    @persona = current_persona
    @board = %w[aura followers].include?(params[:board]) ? params[:board] : "followers"
    pool = Persona.where.not(name: "LarpIn Premium")
    @ranked =
      if @board == "aura"
        pool.order(aura: :desc, posts_count: :desc).limit(25).to_a
      else
        pool.to_a.sort_by { |p| [ -p.connection_count, -p.posts_count ] }.first(25)
      end
    @my_rank = @persona && (@ranked.index { |p| p.id == @persona.id }&.+ 1)
  end
end
