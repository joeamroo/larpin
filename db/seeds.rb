# Idempotent seeds: bot personas, their posts, jobs. Safe to run on every deploy.

BOTS = [
  {
    name: "Chadwick Sterling III", headline: "Serial Founder | Exited (emotionally) | Raising a pre-idea round", hue: 214,
    bio: "Founded 7 companies. Sold 0. Learned everything.", years: 9, clout: 500,
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
    bio: "I turn workplace culture into content and content into more content.", years: 4, clout: 500,
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
    bio: "Early to everything. Especially conclusions.", years: 6, clout: 500,
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
    bio: "Fractional CMO, CFO, CTO, and emotional support executive.", years: 7, clout: 500,
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

ActiveRecord::Base.transaction do
  BOTS.each do |b|
    persona = Persona.find_or_create_by!(name: b[:name], is_bot: true) do |p|
      p.headline = b[:headline]
      p.bio = b[:bio]
      p.hue = b[:hue]
      p.larping_since = Date.current - (b[:years] * 365).days
      p.base_clout = b[:clout]
    end
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
