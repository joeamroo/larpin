<p align="center">
  <img src="docs/media/logo.png" alt="LarpIn: LinkedIn, but everyone admits they're larping" width="640">
</p>

<h1 align="center">LarpIn</h1>

<p align="center"><strong>LinkedIn, but everyone admits they're larping.</strong></p>

<p align="center">
  Live at <a href="https://larpin-production.up.railway.app">larpin-production.up.railway.app</a>
</p>

Half of LinkedIn already reads like performance art: the 4 AM routines, the layoffs that
become personal wins, the stories that end in "and that intern was me." LarpIn is the
honest version. A professional network where every post is openly a performance, every
persona is fake, and everyone commits to the bit.

## What's inside

- One global infinite feed with Hot / Recent / Top sorting
- Instant personas: no signup, you get a generated identity on first visit
  (optional claim with email + password, zero verification, obviously)
- Parody reactions: Inspiring, Congrats, Insightful, Grindset, Cap, Crying at the Gym
- Larp Level: every post scored 0-100 on buzzword density, from "Aspiring Larper"
  to "Final Boss of LinkedIn"
- Hype Squad: summon 3 bots to comment "I felt this in my portfolio" on your post
- A jobs board where Easy Apply rejects you instantly
- LarpIn News: citizen journalism, minus the journalism
- LarpIn Premium: $0/month, billed never; the gold badge does nothing, and Search
  is gated behind it (it was always free to build, we just gated it)
- Profiles with unverifiable experience, custom skills with endorsements,
  instant course certifications, and the #OpenToLarp green ring
- DMs, connections, fake notifications ("Your post was viewed by 3 VCs")
- An AI "Enhance my larp" button that rewrites your draft into maximum hustle-cringe
  (Claude when ANTHROPIC_API_KEY is set, deterministic fallback otherwise)
- 13 seeded bot personas, including one actual medieval LARPer who joined by mistake

## Screenshots

The feed. Every number you see is fabricated, including this sentence's confidence:

<img src="docs/media/feed.png" alt="The LarpIn feed" width="900">

First-visit welcome, where registration gets larped for you:

<img src="docs/media/welcome.png" alt="Welcome dialog with instant persona" width="900">

A profile, featuring the only verified work experience on the entire site:

<img src="docs/media/profile.png" alt="Sir Reginald of Larpshire's profile" width="900">

<p>
  <img src="docs/media/premium.png" alt="LarpIn Premium pricing page" width="620">
  <img src="docs/media/mobile.png" alt="Mobile feed" width="220">
</p>

## Stack

Rails 8.1, Ruby 3.4, SQLite, Hotwire (Turbo + Stimulus), Tailwind v4, ActiveStorage.
No JavaScript build step, no external services required. One box.

## Running it locally

```bash
git clone https://github.com/joeamroo/larpin.git
cd larpin
bundle install
bin/rails db:prepare db:seed
bin/dev            # or: bin/rails server
```

That's it. The seeds give you the full bot cast and content.

Optional env vars:

- `ANTHROPIC_API_KEY` - real AI larp enhancement (claude-haiku-4-5)
- `ADMIN_TOKEN` - enables `DELETE /admin/posts/:id?token=...` moderation endpoints

## Contributing

Yes please. The bar for contributions is: **does it make the bit funnier or the
clone more accurate?**

Great first contributions:

- New bot personas with post histories (see `db/seeds.rb`, match the committed-to-the-bit tone)
- More fake courses, job rejections, hype comments, fake notification viewers
- New parody features (LinkedIn ships self-parody constantly; we must keep pace)
- UI fidelity fixes that make it look more like the real thing
- Bug fixes, always

Open an issue or a PR. Keep copy free of em dashes (house style) and keep the satire
punching at hustle culture, not at individuals.

## License

MIT. Larp responsibly.

Built by [Youssef of Montrose Labs](https://montroselabs.ai) ([@joseamroo](https://x.com/joseamroo)).
