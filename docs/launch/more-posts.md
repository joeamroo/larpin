# LarpIn: remaining post drafts

## Saturday X teaser (with docs/media/logo.png or the thumbnail)

Tomorrow I'm launching the most honest professional network ever built.

Every persona is fake. Every metric is inflated. Everyone knows. Everyone
posts anyway.

Full demo video tomorrow. The medieval LARPer in the seed data is already
waiting for you.

## r/InternetIsBeautiful (Monday, link post)

Title: A social network where everyone is openly pretending to be a
professional. No signup, you get a fake persona generated on arrival.

(Link post to https://larpin.io; add one comment answering "what is this"
with the short pitch and the open source link.)

## r/ProgrammerHumor (Thursday, image post, NOT a link post)

Image: screenshot a single great post card showing a "Larp Lv. 87" chip and
absurd content, or the Premium pricing page (the funniest single frame).
Take a fresh crop from https://larpin.io (a post by Chadwick or Maverick).

Title options:
- I built a LinkedIn clone where the reactions are Grindset, Labubu, and
  Larp Larp Larp Sahur
- My social network scores every post on buzzword density. This one hit
  "Final Boss of LinkedIn"

First comment: link + "open source, the Larp Level scoring function is 30
lines of Ruby and I will defend every weight in it."

## r/rails (Thursday, text post)

Title: I built a full parody social network in Rails 8 in 4 days: feed,
DMs, auth, uploads, one SQLite box, no JS build

Body:
Wanted to share the stack because it was absurdly productive: Rails 8.1,
SQLite in production (with a Railway volume), Hotwire for the infinite feed
and live reactions, Tailwind v4 via tailwindcss-rails, importmap (zero node
build), ActiveStorage for avatars/covers/post images, bcrypt optional-auth
on top of cookie personas.

Things that surprised me:
- SQLite prod defaults in Rails 8 are genuinely launch-ready for a side
  project. One box, no ops.
- Turbo lazy-loaded frames make infinite scroll ~15 lines total.
- The entire "AI feature" has a deterministic fallback, so the app needs
  zero external services to run.

The product itself is a joke (LinkedIn parody where everyone admits they're
faking it) but the codebase is a serious Rails 8 reference:
github.com/joeamroo/larpin. Live at larpin.io. Happy to answer anything
about the stack.

## Indie Hackers (Sunday wrap-up)

Title: Launched a parody LinkedIn in a week: here's what worked

Body: numbers from HN/PH/Reddit (fill in), what drove signups, the
Larpboard-as-retention insight, open source angle, built with Claude Code.
Honest, metrics-first, link at the end.

## dev.to writeup outline (Sunday)

Title: I built a LinkedIn parody in 4 days with Claude Code

Sections: the idea (satire as spec), the stack (Rails 8 one-box), the fun
parts (Larp Level scorer, Hype Squad, gating Search behind fake Premium),
the launch (what HN/PH/Reddit each did), what I'd do differently. Links to
repo, larpin.io, and both other products. Cross-post to Hashnode.
