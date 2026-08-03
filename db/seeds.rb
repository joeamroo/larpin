# Idempotent seeds: bot personas, their posts, jobs. Safe to run on every deploy.

BOTS = [
  {
    name: "Chadwick Sterling III", headline: "Serial Founder | Exited (emotionally) | Raising a pre-idea round", hue: 214,
    bio: "Founded 7 companies. Sold 0. Learned everything.", years: 9, clout: 534,
    posts: [
      { body: <<~POST },
        I rejected a $10M acquisition offer this morning.

        Was there an offer? Legally, I can't say there was.

        But the discipline it took to reject it? That was real.

        Lesson: you don't need opportunities to practice saying no to them.

        #Grindset #FounderLife #Discipline
      POST
      { body: <<~POST }
        My 4-year-old asked me what I do for work.

        I told her: "Daddy creates shareholder value."

        She started crying.

        The market isn't ready for this generation. Bullish.
      POST
    ]
  },
  {
    name: "Brynlee Vance", headline: "Chief Vibes Officer | LinkedIn Top Voice (disputed) | DMs open for synergy", hue: 330,
    bio: "I turn workplace culture into content and content into more content.", years: 4, clout: 521,
    posts: [
      { body: <<~POST },
        An intern said "good morning" to me today.

        Not "good morning, Chief Vibes Officer."

        Just... "good morning."

        I promoted her on the spot. That's the kind of flat-hierarchy energy we manufacture here.

        Culture isn't built. It's performed. 👇
      POST
      { body: "Celebrating 4 years of larping on LarpIn. The character development has been unreal. Literally.", kind: "celebration" }
    ]
  },
  {
    name: "Maverick Blackwood", headline: "Navy SEAL (self-certified) | Alpha Male Coach | God's strongest intern", hue: 20,
    bio: "I have never been in the military but I have watched every documentary.", years: 2, clout: 499,
    posts: [
      { body: <<~POST }
        People ask me: "Maverick, were you actually a Navy SEAL?"

        Wrong question.

        The right question: "Maverick, do you operate with the intensity of a Navy SEAL?"

        Also no. But I wake up at 3:45 AM to think about it.

        Stay hard. Stay hydrated. Stay legally ambiguous.
      POST
    ]
  },
  {
    name: "Aspen Hawthorne", headline: "Web5 Pioneer | Angel-ish Investor | Portfolio: trust me", hue: 265,
    bio: "Early to everything. Especially conclusions.", years: 6, clout: 509,
    posts: [
      { body: <<~POST }
        In 2021 I said crypto was the future. Down 94%.
        In 2023 I said AI was the future. My AI girlfriend left me.
        In 2026 I'm saying Web5 is the future.

        Some of you will screenshot this to mock me.
        The rest of you are my seed round. 🚀

        DM me. Not financial advice. Nothing I do is advice.
      POST
    ]
  },
  {
    name: "Sir Reginald of Larpshire", headline: "Actual LARPer | Level 12 Paladin | Foam Sword Certified", hue: 120,
    bio: "I joined this site because the name suggested it was for my community. I now understand it is something else entirely. I have chosen to stay.", years: 14, clout: 87,
    posts: [
      { body: <<~POST },
        Genuinely confused by this platform.

        I came here to discuss boffer weapon safety and camp logistics for Battle of the Five Meadows III.

        Instead everyone is pretending to be executives? Wearing costumes called "suits"? Reciting incantations like "circle back" and "value-add"?

        Honestly... this might be the largest LARP ever organized. Respect.

        See you all at dawn. Bring your own chainmail.
      POST
      { body: <<~POST }
        Hot take: you people are better at LARPing than my entire guild.

        My cousin Dennis has played a dwarf blacksmith for 6 years and even HE breaks character sometimes.

        You people NEVER break. "Synergy." "Deliverables." "Q3." Incredible worldbuilding. Fully committed ensemble cast.

        10/10 immersion. Would recommend this server.
      POST
    ]
  },
  {
    name: "Journey Whitmore", headline: "10x Generalist | Ex-Stealth | Currently fasting (day 4)", hue: 45,
    bio: "I do everything. Ask me what I've shipped. Actually don't.", years: 3, clout: 212,
    posts: [
      { body: <<~POST }
        Day 4 of my fast.

        I just closed a deal in a dream. Woke up and invoiced them anyway.

        Hunger is just ambition your stomach can hear. 👇

        #5AMClub #Fasting #B2B
      POST
    ]
  },
  {
    name: "Knox Fairbanks", headline: "Grindset Architect | Mentored by a podcast | No Days Off (37 days off this year)", hue: 200,
    bio: "Building my personal brand one repost at a time.", years: 1, clout: 47,
    posts: [
      { body: <<~POST }
        I gave up my apartment to live in my car to save money.

        The car is a Mercedes G-Wagon I lease for $2,100/month.

        Sacrifice looks different for everyone. Stop judging. Start grinding.
      POST
    ]
  },
  {
    name: "Marlowe Sinclair", headline: "Fractional Everything | Keynote Haver | Views are my sponsor's own", hue: 350,
    bio: "Fractional CMO, CFO, CTO, and emotional support executive.", years: 7, clout: 502,
    posts: [
      { body: <<~POST }
        A student asked me for free advice after my keynote.

        I said: "My advice is: nothing is free."

        He said that was actually really helpful.

        I invoiced him $40. He paid. That kid is going places. I'm taking 10% of wherever that is.
      POST
    ]
  },
  {
    name: "Paisley Mercer", headline: "Sigma Analyst | Down 40% but locked in | Forbes 30 Under 30 (waitlist)", hue: 180,
    bio: "I analyze markets, vibes, and my enemies.", years: 2, clout: 86,
    posts: [
      { body: <<~POST }
        My portfolio is down 40%.

        My conviction is up 400%.

        Net-net, I'm up 360%. This is called sigma math and they don't teach it in schools because it would end the banking industry overnight.
      POST
    ]
  },
  {
    name: "Ridge Steele", headline: "Gym Larper | Natty (asterisk) | Cold Plunge Evangelist", hue: 5,
    bio: "The pump is real. The lifts in my stories are not.", years: 5, clout: 312,
    posts: [
      { body: <<~POST }
        Hit a 500lb deadlift this morning.

        No video. The gym's cameras were down. My training partner blinked.

        You'll just have to trust me, which is also my approach to client acquisition.

        😤 #NoDaysOff
      POST
    ]
  },
  {
    name: "Waverly Locke", headline: "Building in Public | 0 users, 14 investors interested | Stealth (loud)", hue: 285,
    bio: "Shipping daily. Mostly tweets.", years: 1, clout: 12,
    posts: [
      { body: <<~POST }
        Month 11 of building in public:

        📈 Revenue: $0
        📈 Users: 0 (2 if you count my mom's two accounts)
        📈 Investor interest: ATH
        📈 Personal growth: immeasurable

        The metrics that matter can't be measured. That's why I don't measure them.
      POST
    ]
  },
  {
    name: "Sloane Ashford", headline: "Ex-FAANG (rejected twice) | Productivity Influencer | 5AM Club Regional Chapter President", hue: 155,
    bio: "I optimize mornings professionally.", years: 3, clout: 500,
    posts: [
      { body: <<~POST }
        My morning routine:

        ⏰ 3:30 AM: Wake up
        🧊 3:35 AM: Cold plunge
        📓 4:00 AM: Journal about the cold plunge
        🎙️ 4:30 AM: Record podcast about the journal
        😴 5:15 AM: Secret nap (do not include this in the carousel)
        📱 9:00 AM: Post carousel

        Discipline. 👇
      POST
    ]
  },
  {
    name: "LarpIn Premium", headline: "Sponsored | Definitely a real company", hue: 40,
    bio: "The gold badge does nothing. That's the point.", years: 10, clout: 500,
    posts: [
      { body: "Tired of larping for free? LarpIn Premium gives you a gold badge, the ability to see who ignored your profile, and absolutely nothing else. $0/month, billed never.", kind: "promoted" },
      { body: "SPONSORED: HustleU MBA. Learn to say \"let's double-click on that\" in 14 languages. Accreditation pending since 2019.", kind: "promoted" }
    ]
  }
].freeze

JOBS = [
  { title: "Chief Vibes Officer", company: "Synergy Labs (Stealth)", location: "Remote (must live in office)", comp: "Equity only (0.0001%)", description: "We're a family. A family that can fire you. Own the vibe roadmap. KPI: goosebumps per all-hands." },
  { title: "10x Engineer (must be 10 engineers)", company: "ScaleFast AI", location: "SF or your car", comp: "$1 salary + exposure", description: "Ship the entire product solo. On-call forever. Free kombucha on days we raise." },
  { title: "Thought Leader Intern", company: "Personal Brand Inc.", location: "LinkedIn", comp: "Unpaid, but you may say you were paid", description: "Ghostwrite vulnerability. Must cry on camera (tastefully). Portfolio of viral hooks required." },
  { title: "Foam Weapons Quartermaster", company: "Larpshire Realm Events", location: "The Five Meadows", comp: "$22/hr + mead", description: "The only real job on this board. Maintain boffer inventory, enforce safety briefings, respect the lore. Posted by Sir Reginald, who still does not fully understand this website." },
  { title: "VP of Circling Back", company: "Enterprise Synergies Group", location: "Hybrid (all meetings could be emails)", comp: "$400k OTE (on-target enthusiasm)", description: "Own the follow-up motion end-to-end. 15+ years of experience touching base required." }
].freeze

# One-time spread for personas already stuck on the old un-jittered top tier. Every
# visitor who rolled 1247 tied at exactly that number and filled all 25 Larpboard slots.
# Deterministic on id, so this is idempotent: once moved off 1247 a row never matches again.
Persona.where(is_bot: false, base_clout: 1247).find_each do |p|
  p.update_column(:base_clout, 1247 + (p.id * 37) % 400)
end

ActiveRecord::Base.transaction do
  BOTS.each do |b|
    persona = Persona.find_or_create_by!(name: b[:name], is_bot: true) do |p|
      p.headline = b[:headline]
      p.bio = b[:bio]
      p.hue = b[:hue]
      p.larping_since = Date.current - (b[:years] * 365).days
      p.base_clout = b[:clout]
    end
    # The block above only runs on create, so bots seeded before base_clout existed kept
    # the column default of 0. That made every follower count collapse to the same number
    # (base_clout 0 + the same auto-connection from every visitor), so the Larpboard was a
    # 25-way tie. Reassert it every boot to keep the ranking real.
    persona.update_column(:base_clout, b[:clout]) if persona.base_clout != b[:clout]
    b[:posts].each do |post|
      next if persona.posts.exists?(body: post[:body])
      created = persona.posts.create!(body: post[:body], kind: post[:kind] || "post")
      # Stagger creation times so the launch feed doesn't look like one bulk insert
      created.update_columns(created_at: rand(1..96).hours.ago, updated_at: Time.current)
    end
  end

  default_poster = Persona.find_by!(name: "Chadwick Sterling III", is_bot: true)
  reginald = Persona.find_by(name: "Sir Reginald of Larpshire", is_bot: true)
  JOBS.each do |j|
    Job.find_or_create_by!(title: j[:title], company: j[:company]) do |job|
      job.persona = j[:title].include?("Foam") && reginald ? reginald : default_poster
      job.location = j[:location]
      job.comp = j[:comp]
      job.description = j[:description]
    end
  end

  bots = Persona.bots.to_a

  # Bots endorse each other so profiles look lived-in
  if Endorsement.none? && bots.size > 3
    bots.each do |p|
      bots.sample(3).each do |endorser|
        next if endorser.id == p.id
        Endorsement.find_or_create_by!(persona: p, endorser: endorser, skill: Endorsement::SKILLS.sample)
      end
    end
  end

  # Bots react to each other's posts so the feed has engagement on day one
  if Reaction.none?
    Post.feed.find_each do |post|
      bots.sample(rand(2..6)).each do |bot|
        next if bot.id == post.persona_id
        Reaction.find_or_create_by!(post: post, persona: bot) { |r| r.kind = Reaction::KINDS.keys.sample }
      end
    end
  end
end

puts "Seeded: #{Persona.bots.count} bots, #{Post.count} posts, #{Job.count} jobs"

# --- LinkedIn-feature seeds: news articles, experiences, profile skills ---

ARTICLES = [
  { author: "Chadwick Sterling III", headline: "Man adds \"CEO\" to profile, becomes CEO",
    body: "In a stunning display of manifestation, a local man updated his LarpIn headline to \"CEO\" and reports that he is now, in every way that matters to him, a CEO.\n\nSources close to the matter (his mom's two accounts) confirm the promotion. The company remains in stealth. The company remains unincorporated. The company remains a Notes app entry.\n\nMarkets were unmoved but supportive." },
  { author: "Paisley Mercer", headline: "Study: 100% of open rates are imagined",
    body: "A groundbreaking study of one inbox found that every reported open rate was either imagined, rounded up, or both.\n\n\"We ran the numbers,\" said the study's author, sole participant, and peer reviewer. \"Then we ran them again until they looked better.\"\n\nThe study has been cited 4,000 times, all by its author." },
  { author: "Brynlee Vance", headline: "Local thought leader runs out of thoughts",
    body: "Tragedy struck the content ecosystem this week when a prominent thought leader posted a carousel containing zero thoughts.\n\nFollowers described the carousel as \"still pretty inspiring\" and \"honestly indistinguishable from the others.\"\n\nHe is expected to make a full recovery by repurposing old thoughts." },
  { author: "Waverly Locke", headline: "\"We're hiring\" post author admits nothing is hiring",
    body: "The author of a viral \"We're hiring!\" post has come forward to clarify that nothing, in fact, is hiring.\n\n\"The post was aspirational,\" they explained. \"Like everything else on this platform.\"\n\n8,914 applicants have been instantly rejected as a precaution." },
  { author: "Sir Reginald of Larpshire", headline: "Battle of the Five Meadows III postponed; corporate larpers invited as consultants",
    body: "The realm's premier boffer engagement has been postponed after organizers realized the corporate larpers of this website maintain character consistency far exceeding guild standards.\n\n\"We have much to learn from them,\" said the Quartermaster. \"They say 'per my last email' with a conviction Dennis has never achieved as a dwarf blacksmith.\"\n\nConsulting rates: exposure and mead." }
].freeze

EXPERIENCES = {
  "Chadwick Sterling III" => [
    { title: "Founder & CEO", company: "Stealth Startup VII", start_year: 2024, end_year: nil, description: "Pre-revenue. Pre-product. Pre-idea. Post-confidence." },
    { title: "Founder & CEO", company: "Stealth Startups I through VI", start_year: 2017, end_year: 2024, description: "Six consecutive learning experiences. All exits were emotional." }
  ],
  "Sir Reginald of Larpshire" => [
    { title: "Foam Weapons Quartermaster", company: "Larpshire Realm Events", start_year: 2012, end_year: nil, description: "The only verified work experience on this entire website. Boffer inventory: immaculate. Safety briefings: legendary." },
    { title: "Level 12 Paladin", company: "Order of the Five Meadows", start_year: 2014, end_year: nil, description: "Oathkeeper. Meadow defender. Reigning champion, Dennis division." }
  ],
  "Maverick Blackwood" => [
    { title: "Alpha Male Coach", company: "Self-Employed (Extremely)", start_year: 2024, end_year: nil, description: "Coaching men to operate at intensities that are, legally speaking, self-certified." },
    { title: "Navy SEAL (self-certified)", company: "The Ocean (adjacent)", start_year: 2023, end_year: 2024, description: "Watched every documentary. Twice. At 3:45 AM." }
  ],
  "Sloane Ashford" => [
    { title: "Productivity Influencer", company: "The 5AM Club, Regional Chapter", start_year: 2023, end_year: nil, description: "President. Founder. Sole member awake." },
    { title: "Software Engineer", company: "FAANG (rejected twice)", start_year: 2022, end_year: 2022, description: "Two interviews. Two growth opportunities. Zero offers. Ex-FAANG in spirit." }
  ],
  "Brynlee Vance" => [
    { title: "Chief Vibes Officer", company: "Culture Inc.", start_year: 2022, end_year: nil, description: "Own the vibe roadmap. KPI: goosebumps per all-hands. Exceeded targets 9 quarters straight." }
  ],
  "Waverly Locke" => [
    { title: "Founder (Building in Public)", company: "Untitled Startup (loud stealth)", start_year: 2025, end_year: nil, description: "0 users, 14 investors interested. The metrics that matter can't be measured." }
  ]
}.freeze

PROFILE_SKILLS = {
  "Chadwick Sterling III" => [ "Saying No to Imaginary Offers", "Shareholder Value", "Stealth Mode" ],
  "Sir Reginald of Larpshire" => [ "Boffer Safety", "Chainmail Maintenance", "Staying In Character" ],
  "Maverick Blackwood" => [ "Waking Up at 3:45 AM", "Intensity", "Legal Ambiguity" ],
  "Sloane Ashford" => [ "Cold Plunges", "Carousel Design", "Secret Naps" ],
  "Brynlee Vance" => [ "Vibes", "Flat Hierarchy Theater", "Culture Manufacturing" ],
  "Paisley Mercer" => [ "Sigma Math", "Conviction", "Loss Reframing" ],
  "Waverly Locke" => [ "Building in Public", "Investor Interest Generation", "Metric Immeasurability" ],
  "Journey Whitmore" => [ "Fasting Through Meetings", "Dream Invoicing", "Generalism" ],
  "Knox Fairbanks" => [ "G-Wagon Minimalism", "Sacrifice Optics", "Reposting" ],
  "Marlowe Sinclair" => [ "Fractional Everything", "Invoicing Students", "Keynote Having" ],
  "Ridge Steele" => [ "Unwitnessed Deadlifts", "Cold Plunge Evangelism", "Trust-Based PRs" ]
}.freeze

ActiveRecord::Base.transaction do
  ARTICLES.each do |a|
    author = Persona.find_by(name: a[:author], is_bot: true)
    next unless author
    next if Article.exists?(headline: a[:headline])
    article = author.articles.create!(headline: a[:headline], body: a[:body])
    article.update_columns(created_at: rand(2..48).hours.ago, updated_at: Time.current)
  end

  EXPERIENCES.each do |name, rows|
    persona = Persona.find_by(name: name, is_bot: true)
    next unless persona
    rows.each do |row|
      Experience.find_or_create_by!(persona: persona, title: row[:title], company: row[:company]) do |e|
        e.start_year = row[:start_year]
        e.end_year = row[:end_year]
        e.description = row[:description]
      end
    end
  end

  all_bots = Persona.bots.to_a
  PROFILE_SKILLS.each do |name, skills|
    persona = Persona.find_by(name: name, is_bot: true)
    next unless persona
    skills.each { |s| ProfileSkill.find_or_create_by!(persona: persona, name: s) }
    next if persona.endorsements.where(skill: skills).any?
    skills.each do |s|
      all_bots.reject { |b| b.id == persona.id }.sample(rand(1..4)).each do |endorser|
        Endorsement.find_or_create_by!(persona: persona, endorser: endorser, skill: s)
      end
    end
  end
end

puts "Seeded LinkedIn features: #{Article.count} articles, #{Experience.count} experiences, #{ProfileSkill.count} skills"

# --- LarpIn Learning: bots hold certifications ---
ActiveRecord::Base.transaction do
  Persona.bots.find_each do |bot|
    next if bot.certifications.any?
    Certification::COURSES.sample(2).each do |c|
      Certification.find_or_create_by!(persona: bot, course: c[:course]) { |cert| cert.hours = c[:hours] }
    end
  end
  reginald = Persona.find_by(name: "Sir Reginald of Larpshire", is_bot: true)
  if reginald
    Certification.find_or_create_by!(persona: reginald, course: "Boffer Safety Level 1 (the only real course here)") { |c| c.hours = "8 hours" }
  end
end

puts "Seeded certifications: #{Certification.count}"

# --- Premium and open-to-larp flags for bots ---
Persona.where(name: [ "Chadwick Sterling III", "Sloane Ashford", "LarpIn Premium", "Marlowe Sinclair" ], is_bot: true).update_all(premium: true)
Persona.where(name: [ "Sir Reginald of Larpshire", "Waverly Locke" ], is_bot: true).update_all(open_to_larp: true)
puts "Flags set: #{Persona.where(premium: true).count} premium, #{Persona.where(open_to_larp: true).count} open to larp"

# --- Meme-feature seeds: aura, verified, pilled/coded, a couple polls ---
ActiveRecord::Base.transaction do
  Persona.bots.find_each do |bot|
    bot.update_columns(
      aura: bot.base_clout * 2 + rand(0..400),
      verified: bot.base_clout >= 500,
      pilled: Persona::PILLED.sample,
      coded: Persona::CODED.sample,
      streak: [ 0, 0, 3, 7, 12, 47 ].sample
    )
  end

  poller = Persona.find_by(name: "Brynlee Vance", is_bot: true)
  if poller && poller.posts.where(kind: "poll").none?
    p1 = poller.posts.create!(kind: "poll", body: "Is it larping or is it just Tuesday?",
      poll_options: [ "Larping", "Just Tuesday", "Both, honestly", "I'm too locked in to know" ])
    p1.update_columns(created_at: rand(2..30).hours.ago)
    reg = Persona.find_by(name: "Sir Reginald of Larpshire", is_bot: true)
    if reg && reg.posts.where(kind: "poll").none?
      p2 = reg.posts.create!(kind: "poll", body: "Foam sword or corporate jargon: which is the more powerful weapon?",
        poll_options: [ "Foam sword", "The phrase 'circle back'", "Both are boffer-legal" ])
      p2.update_columns(created_at: rand(2..30).hours.ago)
    end
    # scatter votes from bots
    Post.where(kind: "poll").find_each do |poll|
      Persona.bots.where.not(id: poll.persona_id).sample(rand(4..9)).each do |voter|
        PollVote.find_or_create_by!(post: poll, persona: voter) { |v| v.choice = rand(0...poll.poll_options.size) }
      end
    end
  end
end
puts "Meme seeds: aura set, #{Post.where(kind: 'poll').count} polls, #{Persona.where(verified: true).count} verified"

# --- Global chat room ---------------------------------------------------------
# The dock's Global Chat is a live room, but an empty box on arrival kills it.
# Seed a few bot lines so the first visitor walks into a conversation already
# in progress. Idempotent: only runs when the room is genuinely empty.
if GlobalMessage.count.zero?
  bots = Persona.bots.to_a
  if bots.any?
    opening_lines = [
      "Good morning to everyone except the people who did not congratulate me on my work anniversary.",
      "Quick poll: is 4:45 AM early, or is it just when the day starts for people who want it?",
      "Does anyone here actually do a job, or are we all between opportunities in a strategic way",
      "I have been in this room six minutes and I have already been added to two newsletters.",
      "Genuinely one of the strongest rooms I have ever been in. I have not read a single message."
    ]
    opening_lines.each_with_index do |line, i|
      GlobalMessage.create!(persona: bots[i % bots.size], body: line,
                            created_at: (opening_lines.size - i).minutes.ago)
    end
  end
end
puts "Global chat: #{GlobalMessage.count} messages"
