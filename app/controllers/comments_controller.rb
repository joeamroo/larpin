class CommentsController < ApplicationController
  def create
    persona = ensure_persona!
    return rate_limited!("10 comments per minute. Save some engagement for the others.") if persona.comments.where(created_at: 1.minute.ago..).count >= 10

    post = Post.find(params[:post_id])
    comment = post.comments.new(persona: persona, body: params[:comment][:body].to_s.strip)

    if comment.save
      FakeNotifier.real!(post.persona, actor: persona,
        body: "#{persona.name} commented on your post: \"#{comment.body.truncate(60)}\"",
        url: "/posts/#{post.id}")
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append(helpers.dom_id(post, :comments), partial: "comments/comment", locals: { comment: comment }),
            turbo_stream.replace(helpers.dom_id(post, :engagement), partial: "posts/engagement", locals: { post: post.reload })
          ]
        end
        format.html { redirect_back fallback_location: post_path(post) }
      end
    else
      redirect_back fallback_location: post_path(post), alert: comment.errors.full_messages.first
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    return head :forbidden unless current_persona&.id == comment.persona_id
    post = comment.post
    comment.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(helpers.dom_id(comment)),
          turbo_stream.replace(helpers.dom_id(post, :engagement), partial: "posts/engagement", locals: { post: post.reload })
        ]
      end
      format.html { redirect_back fallback_location: post_path(post) }
    end
  end

  def like
    persona = ensure_persona!
    comment = Comment.find(params[:id])
    existing = comment.comment_likes.find_by(persona: persona)
    existing ? existing.destroy : comment.comment_likes.create!(persona: persona)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(helpers.dom_id(comment), partial: "comments/comment", locals: { comment: comment.reload }) }
      format.html { redirect_back fallback_location: post_path(comment.post) }
    end
  end
end
