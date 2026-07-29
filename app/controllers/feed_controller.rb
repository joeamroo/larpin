class FeedController < ApplicationController
  PER_PAGE = 8

  def index
    ensure_persona! unless request.headers["Turbo-Frame"]
    @sort = %w[hot new top].include?(params[:sort]) ? params[:sort] : "hot"
    @page = [params[:page].to_i, 1].max
    @posts = Post.feed.includes(:persona, images_attachments: :blob)
                 .sorted(@sort)
                 .offset((@page - 1) * PER_PAGE).limit(PER_PAGE + 1).to_a
    @has_next = @posts.length > PER_PAGE
    @posts = @posts.first(PER_PAGE)
    @promoted = Post.promoted.order("RANDOM()").first if @posts.any?

    render :frame, layout: false if @page > 1
  end
end
