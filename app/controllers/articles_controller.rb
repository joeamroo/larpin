class ArticlesController < ApplicationController
  def index
    @articles = Article.latest.includes(:persona).limit(50)
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    ensure_persona!
    @article = Article.new
  end

  def create
    persona = ensure_persona!
    return rate_limited!("3 breaking stories per minute maximum. Even cable news paces itself.") if persona.articles.where(created_at: 1.minute.ago..).count >= 3

    @article = persona.articles.new(params.require(:article).permit(:headline, :body))
    if @article.save
      redirect_to article_path(@article), notice: "Published. The news cycle is now yours."
    else
      flash.now[:alert] = @article.errors.full_messages.first
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    article = current_persona&.articles&.find_by(id: params[:id])
    return head :forbidden unless article
    article.destroy
    redirect_to articles_path, notice: "Retracted. Journalism."
  end
end
