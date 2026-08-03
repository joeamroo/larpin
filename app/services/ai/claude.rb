require "net/http"
require "json"

# One place for every Claude call in the app.
#
# Three things matter here and nothing else does:
#
#   1. It never raises into a request. Every caller has a deterministic fallback,
#      so a timeout, a 429, or a missing key just means the app behaves the way
#      it did before the AI existed.
#   2. It never spends past the daily budget. AiUsage is the ledger and the cap
#      is checked BEFORE the call, not after.
#   3. It is only ever reached from a user-initiated action. Nothing on a cold
#      visitor's first page load touches this, so passive traffic costs $0.
module Ai
  module Claude
    ENDPOINT = "https://api.anthropic.com/v1/messages".freeze
    API_VERSION = "2023-06-01".freeze

    # Two tiers, chosen by measuring the actual joke output rather than by price.
    #
    #   showcase : Larpmaxx and Enhance, the two buttons people screenshot. Fable
    #              wrote the funniest lines of the three models tested ("commenting
    #              'per our data retention policy' on wedding announcements"), and
    #              a deliberate button press can afford ~5s behind a spinner.
    #   volume   : DM replies and hype-squad comments, where the reply has to land
    #              before the page redraws. Haiku answers in ~2s and is good enough.
    #
    # Fable uses adaptive thinking and refuses thinking.type=disabled, so showcase
    # callers must leave headroom in max_tokens for thinking plus the answer. Too
    # small a budget and the whole allowance goes to thinking, the response comes
    # back with no text block at all, and we quietly fall back for no reason.
    MODELS = {
      showcase: -> { ENV.fetch("LARPIN_AI_MODEL_SHOWCASE", "claude-fable-5") },
      volume: -> { ENV.fetch("LARPIN_AI_MODEL_VOLUME", "claude-haiku-4-5") }
    }.freeze

    def self.key
      ENV["ANTHROPIC_API_KEY"].presence
    end

    def self.configured?
      key.present?
    end

    # Live means: we have a key AND we are under budget. Callers use this to
    # decide whether to even bother building a prompt.
    def self.live?
      configured? && !AiUsage.over_budget?
    end

    def self.model_for(tier)
      MODELS.fetch(tier, MODELS[:volume]).call
    end

    # Returns the generated String, or nil for "use your fallback".
    def self.generate(feature:, system:, user:, tier: :volume, max_tokens: 500, temperature: 1.0, timeout: 8)
      return nil unless live?

      model = model_for(tier)
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      uri = URI(ENDPOINT)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = 4
      http.read_timeout = timeout

      req = Net::HTTP::Post.new(uri)
      req["x-api-key"] = key
      req["anthropic-version"] = API_VERSION
      req["content-type"] = "application/json"
      req.body = {
        model: model,
        max_tokens: max_tokens,
        temperature: temperature,
        system: system,
        messages: [ { role: "user", content: user.to_s.first(4000) } ]
      }.to_json

      res = http.request(req)
      raise "HTTP #{res.code}: #{res.body.to_s.first(200)}" unless res.code == "200"

      body = JSON.parse(res.body)
      # Never index content[0] blindly. Models that think emit a thinking block
      # first, so the answer is not at index 0 and the call silently "succeeds"
      # with an empty string. Collect every text block instead.
      text = Array(body["content"])
             .select { |b| b["type"] == "text" }
             .map { |b| b["text"].to_s }
             .join("\n")
             .strip

      if text.blank?
        raise "empty completion (stop_reason=#{body['stop_reason']}, blocks=#{Array(body['content']).map { |b| b['type'] }.join(',')})"
      end

      usage = body["usage"] || {}
      AiUsage.record!(
        feature: feature,
        model: model,
        input_tokens: usage["input_tokens"].to_i,
        output_tokens: usage["output_tokens"].to_i,
        ms: ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - started) * 1000).round
      )

      scrub(text)
    rescue StandardError => e
      Rails.logger.warn("[Ai::Claude] #{feature} fell back: #{e.class}: #{e.message}")
      nil
    end

    # Models like to wrap output in quotes or open with "Here's your post:".
    # The fallbacks never do that, so strip it and keep the two paths consistent.
    PREAMBLE = /\A(here(?:'s| is)[^\n:]{0,60}:|sure[^\n]{0,40}:)\s*/i

    def self.scrub(text)
      out = text.sub(PREAMBLE, "").strip
      out = out[1..-2].to_s.strip if out.start_with?('"') && out.end_with?('"')
      out.presence
    end
  end
end
