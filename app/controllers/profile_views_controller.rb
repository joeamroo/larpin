class ProfileViewsController < ApplicationController
  VIEWER_TEMPLATES = [
    [ "A recruiter", "typed your name, sighed, and closed the tab" ],
    [ "Someone from your past company", "views your profile every Tuesday. It's been 2 years." ],
    [ "A VC associate", "looked for 4 seconds. That's actually above average." ],
    [ "Your old manager", "viewed you 3 times in incognito. Incognito does not work here." ],
    [ "A LinkedIn Top Voice (disputed)", "screenshotted your headline for a carousel" ],
    [ "Someone in Stealth Mode", "we legally cannot say who. We don't know either." ],
    [ "A podcast host", "is deciding whether your trauma is episode-worthy" ],
    [ "The algorithm", "viewed your profile emotionally" ],
    [ "3 people from Blackstone", "or possibly one person, three times, from Blackstone" ],
    [ "Dennis (dwarf blacksmith)", "broke character to view your profile. Respect." ]
  ].freeze

  def index
    @persona = ensure_persona!
    seed = @persona.id * 31 + Date.current.yday
    @viewer_rows = VIEWER_TEMPLATES.shuffle(random: Random.new(seed)).first(6)
    @view_count = @persona.id * 137 % 9000 + 240
  end
end
