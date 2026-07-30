class SavedPostsController < ApplicationController
  def index
    @persona = ensure_persona!
    @posts = @persona.saved_feed_posts.includes(:persona, images_attachments: :blob)
                     .order("saved_posts.created_at DESC").limit(50)
  end
end
