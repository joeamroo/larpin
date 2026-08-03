# The spend ledger. One row per Claude call, and the hard daily cap that keeps a
# front-page day from turning into a surprise invoice.
#
# Cost is stored in micros (millionths of a dollar) because a single Haiku call
# rounds to zero at cent precision and we want the ledger to actually add up.
class AiUsage < ApplicationRecord
  # $ per million tokens, [input, output]. Estimates, not billing truth: the cap
  # exists to stop runaway spend, not to reconcile the invoice.
  PRICES = {
    "claude-fable-5" => [ 3.0, 15.0 ],
    "claude-sonnet-5" => [ 3.0, 15.0 ],
    "claude-haiku-4-5" => [ 1.0, 5.0 ],
    "claude-haiku-4-5-20251001" => [ 1.0, 5.0 ],
    "claude-opus-5" => [ 15.0, 75.0 ]
  }.freeze

  DEFAULT_PRICE = [ 3.0, 15.0 ].freeze
  BUDGET_CACHE_KEY = "ai_usage:spent_today".freeze

  def self.daily_budget_usd
    ENV.fetch("LARPIN_AI_DAILY_BUDGET_USD", "10").to_f
  end

  def self.cost_micros_for(model, input_tokens, output_tokens)
    in_price, out_price = PRICES.fetch(model, DEFAULT_PRICE)
    ((input_tokens * in_price + output_tokens * out_price)).round
  end

  def self.record!(feature:, model:, input_tokens:, output_tokens:, ms: 0)
    micros = cost_micros_for(model, input_tokens, output_tokens)
    create!(feature: feature, model: model, input_tokens: input_tokens,
            output_tokens: output_tokens, cost_micros: micros, ms: ms)
    Rails.cache.increment(BUDGET_CACHE_KEY, micros, expires_in: 5.minutes)
  rescue StandardError => e
    # A ledger write must never break the feature it is measuring.
    Rails.logger.warn("[AiUsage] record failed: #{e.class}: #{e.message}")
    nil
  end

  def self.spent_micros_today
    # Cached for 5 minutes so a front-page spike is not doing a SUM per request.
    # Worst case we overshoot the cap by 5 minutes of traffic, which is why the
    # default budget is set well under what would actually hurt.
    Rails.cache.fetch(BUDGET_CACHE_KEY, expires_in: 5.minutes) do
      where(created_at: Time.current.beginning_of_day..).sum(:cost_micros)
    end.to_i
  rescue StandardError
    # If the cache or the table is unavailable, fail CLOSED: no key, no spend.
    Float::INFINITY
  end

  def self.spent_today_usd
    spent = spent_micros_today
    spent.infinite? ? 0.0 : spent / 1_000_000.0
  end

  def self.over_budget?
    spent_micros_today >= daily_budget_usd * 1_000_000
  end

  def self.summary
    {
      spent_today_usd: spent_today_usd.round(4),
      budget_usd: daily_budget_usd,
      calls_today: where(created_at: Time.current.beginning_of_day..).count,
      by_feature: where(created_at: Time.current.beginning_of_day..).group(:feature).count,
      live: Ai::Claude.live?
    }
  end
end
