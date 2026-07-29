class Post < ApplicationRecord
  KINDS = %w[post celebration promoted].freeze

  belongs_to :persona, counter_cache: true
  has_many :reactions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many_attached :images

  validates :kind, inclusion: { in: KINDS }
  validates :body, length: { maximum: 4000 }
  validate :body_or_images_present
  validate :images_within_limits

  before_create { self.impressions_seed = rand(2_000..90_000) }

  scope :feed, -> { where(kind: %w[post celebration]) }
  scope :promoted, -> { where(kind: "promoted") }

  # Hot: engagement over a linear time-decay. Computed in SQL so it works
  # straight off the feed query on SQLite.
  HOT_SQL = "((posts.reactions_count * 3.0 + posts.comments_count * 2.0 + 1.0) / " \
            "((julianday('now') - julianday(posts.created_at)) * 24.0 + 2.0))".freeze

  def self.sorted(sort)
    case sort
    when "new" then order(created_at: :desc)
    when "top" then order(reactions_count: :desc, comments_count: :desc, created_at: :desc)
    else order(Arel.sql("#{HOT_SQL} DESC"), created_at: :desc)
    end
  end

  def impressions
    impressions_seed + reactions_count * 137 + comments_count * 291
  end

  LARP_BUZZWORDS = %w[
    synergy grindset hustle blessed mindset disrupt leverage scale alpha sigma
    ceo founder stealth exit pivot journey humbled grateful excited thrilled
    announce 10x b2b saas roi kpi ai vulnerability discipline conviction mentor
    portfolio investors revenue growth locked bullish
  ].freeze

  LARP_TIERS = [
    [20, "Aspiring Larper"],
    [40, "Committed to the Bit"],
    [60, "Method Actor"],
    [80, "Thought Leader"],
    [101, "Final Boss of LinkedIn"]
  ].freeze

  # Deterministic satire: score the post's hustle-cringe density.
  def larp_level
    text = body.to_s.downcase
    score = 0
    score += LARP_BUZZWORDS.count { |w| text.include?(w) } * 8
    score += 8 if body.include?("👇")
    score += 8 if text.match?(/\b[3-5](:\d\d)? ?am\b/)
    score += 10 if text.include?("let that sink in")
    score += 7 if text.match?(/agree\?/)
    score += body.scan(/#[[:alpha:]]/).count.clamp(0, 4) * 4
    score += body.scan(/\n\n/).count.clamp(0, 6) * 3
    score += 5 if text.match?(/\$\d/)
    score += 5 if text.match?(/\d{2,}%/)
    [score, 100].min
  end

  def larp_tier
    LARP_TIERS.find { |max, _| larp_level < max }.last
  end

  def reaction_breakdown
    reactions.group(:kind).count.sort_by { |_, v| -v }
  end

  private

  def body_or_images_present
    errors.add(:body, "can't be empty (even larps need substance)") if body.blank? && images.blank?
  end

  def images_within_limits
    return if images.blank?
    errors.add(:images, "maximum 4 images per larp") if images.size > 4
    images.each do |img|
      errors.add(:images, "must be images") unless img.content_type&.start_with?("image/")
      errors.add(:images, "must be under 8MB each") if img.byte_size > 8.megabytes
    end
  end
end
