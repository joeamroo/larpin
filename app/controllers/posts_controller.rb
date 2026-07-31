class PostsController < ApplicationController
  before_action :set_post, only: [ :show, :destroy, :react, :analytics, :hype, :save, :report, :mog, :vote ]

  def create
    persona = ensure_persona!
    return rate_limited!("4 larps per minute maximum. Quality over quantity.") if persona.posts.where(created_at: 1.minute.ago..).count >= 4

    kind = %w[post celebration poll].include?(params[:post][:kind]) ? params[:post][:kind] : "post"
    post = persona.posts.new(body: params[:post][:body].to_s.strip, kind: kind)
    if kind == "poll"
      options = Array(params[:post][:poll_options]).map { |o| o.to_s.strip }.reject(&:blank?).first(4)
      return redirect_to root_path, alert: "A poll needs at least 2 options. Democracy has standards." if options.size < 2
      post.poll_options = options
    end
    post.images.attach(params[:post][:images].reject(&:blank?)) if params[:post][:images].present?

    if post.save
      persona.add_aura(15)
      persona.touch_streak!
      redirect_to root_path, notice: "Larp published. +15 aura. The algorithm is perceiving you."
    else
      redirect_to root_path, alert: post.errors.full_messages.first
    end
  end

  def show
    @comments = @post.comments.includes(:persona).order(:created_at)
  end

  def destroy
    if current_persona&.id == @post.persona_id
      @post.destroy
      redirect_to root_path, notice: "Larp retracted. Your legacy remains."
    else
      head :forbidden
    end
  end

  def react
    persona = ensure_persona!
    kind = params[:kind]
    return head :unprocessable_entity unless Reaction::KINDS.key?(kind)

    existing = @post.reactions.find_by(persona: persona)
    if existing&.kind == kind
      existing.destroy
    elsif existing
      existing.update!(kind: kind)
    else
      @post.reactions.create!(persona: persona, kind: kind)
      @post.persona.add_aura(2)
      FakeNotifier.real!(@post.persona, actor: persona,
        body: "#{persona.name} reacted #{Reaction::KINDS[kind][:emoji]} #{Reaction::KINDS[kind][:label]} to your post. +2 aura.",
        url: "/posts/#{@post.id}")
    end
    @post.reload

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(helpers.dom_id(@post, :engagement), partial: "posts/engagement", locals: { post: @post }) }
      format.html { redirect_back fallback_location: post_path(@post) }
    end
  end

  def analytics
    render layout: !turbo_frame_request?
  end

  def hype
    return head :forbidden unless current_persona&.id == @post.persona_id
    if HypeSquad.summon!(@post)
      redirect_back fallback_location: post_path(@post), notice: "Hype squad dispatched. Engagement is now organic (contractually)."
    else
      redirect_back fallback_location: post_path(@post), alert: "Your hype squad already came. They have other grinds to attend."
    end
  end

  def save
    persona = ensure_persona!
    existing = persona.saved_posts.find_by(post: @post)
    if existing
      existing.destroy
      redirect_back fallback_location: root_path, notice: "Unsaved. It was never that inspiring."
    else
      persona.saved_posts.create!(post: @post)
      redirect_back fallback_location: root_path, notice: "Saved to My items. You will never look at it again."
    end
  end

  def report
    persona = ensure_persona!
    FakeNotifier.real!(@post.persona, actor: persona,
      body: "Your post was reported to HR. HR does not exist here. Carry on.",
      url: "/posts/#{@post.id}")
    redirect_back fallback_location: root_path, notice: "Reported to HR. HR is a concept. Nothing will happen, and honestly, that's very on-brand."
  end

  def mog
    persona = ensure_persona!
    return redirect_back fallback_location: root_path, alert: "You cannot mog yourself. That's just journaling." if persona.id == @post.persona_id
    if @post.mogs.exists?(persona_id: persona.id)
      return redirect_back fallback_location: root_path, alert: "Already mogged. The dominance stands."
    end
    @post.mogs.create!(persona: persona)
    persona.add_aura(10)
    @post.persona.add_aura(-20)
    FakeNotifier.real!(@post.persona, actor: persona,
      body: "#{persona.name} mogged your post. -20 aura. Log off and recover.",
      url: "/posts/#{@post.id}")
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(helpers.dom_id(@post, :engagement), partial: "posts/engagement", locals: { post: @post.reload }) }
      format.html { redirect_back fallback_location: root_path, notice: "Mogged. +10 aura to you, -20 to them. Ruthless." }
    end
  end

  def vote
    persona = ensure_persona!
    return head :unprocessable_entity unless @post.poll?
    choice = params[:choice].to_i
    @post.poll_votes.find_or_create_by!(persona: persona) { |v| v.choice = choice }
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(helpers.dom_id(@post, :poll), partial: "posts/poll", locals: { post: @post.reload, voted: true }) }
      format.html { redirect_back fallback_location: root_path }
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end
