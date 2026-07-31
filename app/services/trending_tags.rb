# "What larpers are talking about": real hashtags mined from recent posts,
# ranked by frequency, cached briefly so the feed stays fast.
module TrendingTags
  def self.top(limit = 5)
    Rails.cache.fetch("trending_tags/v1", expires_in: 3.minutes) do
      counts = Hash.new(0)
      Post.feed.where(created_at: 3.days.ago..).limit(300).pluck(:body).each do |body|
        body.to_s.scan(/#[[:alpha:]][[:alnum:]_]*/).each { |t| counts[t] += 1 }
      end
      counts.sort_by { |_, c| -c }.first(20)
    end.first(limit)
  end
end
