class SearchController < ApplicationController
  def index
    persona = ensure_persona!
    unless persona.premium?
      return redirect_to premium_path, alert: "Search is a Premium feature. Premium is free. This is the business model."
    end
    @query = params[:q].to_s.strip.first(80)
    if @query.present?
      like = "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%"
      @personas = Persona.where("name LIKE :q OR headline LIKE :q", q: like).limit(10)
      @posts = Post.feed.where("body LIKE :q", q: like).includes(:persona).order(created_at: :desc).limit(20)
      @jobs = Job.where("title LIKE :q OR company LIKE :q", q: like).includes(:persona).limit(10)
    else
      @personas = Persona.none
      @posts = Post.none
      @jobs = Job.none
    end
  end
end
