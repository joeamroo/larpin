require "net/http"
require "json"

# Rewrites a draft into maximum professional cringe. Uses Claude when
# ANTHROPIC_API_KEY is set; otherwise a deterministic template fallback so the
# button works with zero configuration.
module CringeEnhancer
  SYSTEM_PROMPT = <<~PROMPT.freeze
    You rewrite text into a parody of the most insufferable LinkedIn hustle-culture post imaginable.
    Rules: keep the user's core topic. Open with a dramatic one-line hook. Use short punchy lines,
    unnecessary vulnerability, at least one humble-brag, invented metrics, a numbered list of
    "lessons", and end with a question to drive engagement plus 3-5 absurd hashtags. Emojis as
    bullet points. Under 150 words. Return ONLY the rewritten post text.
  PROMPT

  HOOKS = [
    "I wasn't going to share this. But my mentor said the world needs it.",
    "3 years ago I was sleeping on an air mattress. Today, everything changed.",
    "A recruiter just called me crying. Here's why.",
    "This morning at 4:02 AM, my cold plunge taught me something about B2B sales.",
    "I got rejected 47 times last week. I've never felt more alive."
  ].freeze

  LESSONS = [
    "Your network is your net worth.",
    "Sleep is a subscription you can cancel.",
    "Comfort zones are where dreams go to die.",
    "If you're the smartest person in the room, invoice the room.",
    "Discipline is just self-love wearing a suit."
  ].freeze

  CLOSERS = [
    "Agree? 👇", "Thoughts? 👇", "Who else is locked in? 👇",
    "Repost if this resonated. My team reads every share.", "Follow for more raw truths."
  ].freeze

  HASHTAGS = %w[#Grindset #Blessed #ThoughtLeadership #5AMClub #Hustle #Synergy
                #BuildingInPublic #Larping #NoDaysOff #Mindset].freeze

  def self.enhance(text)
    api_key = ENV["ANTHROPIC_API_KEY"]
    if api_key.present?
      begin
        return claude_enhance(text, api_key)
      rescue StandardError => e
        Rails.logger.warn("CringeEnhancer API failure, using fallback: #{e.class}: #{e.message}")
      end
    end
    fallback(text)
  end

  def self.claude_enhance(text, api_key)
    uri = URI("https://api.anthropic.com/v1/messages")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 25
    req = Net::HTTP::Post.new(uri)
    req["x-api-key"] = api_key
    req["anthropic-version"] = "2023-06-01"
    req["content-type"] = "application/json"
    req.body = {
      model: "claude-haiku-4-5",
      max_tokens: 500,
      system: SYSTEM_PROMPT,
      messages: [{ role: "user", content: text.to_s.first(2000) }]
    }.to_json
    res = http.request(req)
    raise "API #{res.code}" unless res.code == "200"
    out = JSON.parse(res.body).dig("content", 0, "text").to_s.strip
    raise "empty response" if out.blank?
    out
  end

  def self.fallback(text)
    seed = text.to_s.sum
    core = text.to_s.strip.first(400)
    lessons = LESSONS.shuffle(random: Random.new(seed)).first(3)
    <<~POST.strip
      #{HOOKS[seed % HOOKS.length]}

      #{core}

      Let that sink in.

      What this taught me:
      #{lessons.each_with_index.map { |l, i| "#{i + 1}. #{l}" }.join("\n")}

      #{CLOSERS[seed % CLOSERS.length]}

      #{HASHTAGS.shuffle(random: Random.new(seed)).first(4).join(" ")}
    POST
  end
end
