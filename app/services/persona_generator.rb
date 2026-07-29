module PersonaGenerator
  FIRST = %w[Chad Brayden Kayleigh Hunter Blake Madison Tanner Skylar Chase Paisley
             Maverick Journey Bryce Kendall Logan Harper Colton Aspen Grant Sloane
             Dax Brinley Knox Emberly Ridge Palmer Cash Waverly Stone Marlowe].freeze
  LAST = %w[Sterling Wolfe Ashford Kingsley Vance Mercer Blackwood Hale Crane Fox
            Steele Monroe Hawthorne Drake Sinclair Locke Fairbanks Grayson Voss Whitmore].freeze

  TITLES = [
    "Visionary", "Serial Founder", "Ex-Stealth", "Angel-ish Investor", "Thought Leader",
    "Chief Vibes Officer", "Fractional Everything", "Keynote Haver", "Navy SEAL (self-certified)",
    "10x Generalist", "Exited (emotionally)", "Building in Public", "Web5 Pioneer",
    "Alpha Male Coach", "Sigma Analyst", "Grindset Architect", "LinkedIn Top Voice (disputed)"
  ].freeze

  SUFFIX = [
    "DMs open for synergy", "Ask me about my morning routine", "We're hiring (not really)",
    "Views are my sponsor's own", "Forbes 30 Under 30 (waitlist)", "Raising a pre-idea round",
    "Down 40% but locked in", "Mentored by a podcast", "God's strongest intern",
    "Currently fasting (day 4)", "Not financial advice", "Portfolio: trust me"
  ].freeze

  def self.generate
    {
      name: "#{FIRST.sample} #{LAST.sample}",
      headline: "#{TITLES.sample} | #{TITLES.sample} | #{SUFFIX.sample}",
      hue: rand(0..359),
      larping_since: Date.current - rand(30..3200).days,
      base_clout: [0, 3, 12, 47, 86, 212, 499, 500, 1247].sample,
      bio: "This persona was procedurally generated, exactly like every story on this site."
    }
  end
end
