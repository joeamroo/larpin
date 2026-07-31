class LarpboardController < ApplicationController
  def index
    @persona = current_persona
    @ranked = Persona.where.not(name: "LarpIn Premium")
                     .sort_by { |p| [ -p.connection_count, -p.posts_count ] }
                     .first(25)
    @my_rank = @persona && (@ranked.index { |p| p.id == @persona.id }&.+ 1)
  end
end
