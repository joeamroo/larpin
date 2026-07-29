# LarpIn Design Spec (2026-07-28)

## Concept

LarpIn is a parody LinkedIn: one global, infinite feed where every kind of internet
larper (hustle bros, crypto visionaries, self-certified Navy SEALs, gym rats, stealth
founders, and one confused actual medieval LARPer) posts in-character. Everyone is in
on the joke; the site rewards the most committed bit. Built to ship fast and launch
on Hacker News.

## Identity

- No signup. First visit auto-generates a persona: fake name, absurd headline,
  gradient initials avatar. Fully editable.
- A signed device cookie owns the persona (edit/delete own content). One persona
  per device.

## Features (MVP, all in scope)

1. Global feed: Hot (default, reaction-weighted with time decay), New, Top.
   Infinite scroll via Turbo Frame lazy-loaded pages.
2. Posts: text with "...see more" truncation, up to 4 images (ActiveStorage,
   8MB/type validated, no variants), post kinds: post, celebration. Bot-only
   kind: promoted (one sprinkled per feed page).
3. Reactions (6, one per persona per post): Inspiring, Congrats, Insightful,
   Grindset, Cap, Crying at the Gym.
4. Comments: flat, with like counts.
5. Sharing: permalink page per post with OG tags (first image as og:image when
   present); share buttons: X, LinkedIn, Reddit, WhatsApp, copy link.
6. Persona profiles: posts, bio, headline, connection count (display caps at
   "500+"), endorsed skills with counts, Endorse and Connect and Message buttons.
7. My Network: pending requests (accept), suggestions, connection list. Seeded
   bots auto-send 2-3 requests + a welcome DM to every new persona.
8. Notifications: real (reactions, comments, connection accepts, DMs) mixed with
   fake ones ("Your post was viewed by 3 VCs..."), generated lazily on visit for
   posts older than 2 minutes. Badge in navbar.
9. Post analytics: per-post "impressions" view with inflated numbers derived from
   a random seed + engagement.
10. LarpIn Jobs: parody job board, anyone can post a listing; Easy Apply instantly
    returns a lovingly written rejection.
11. Messaging: persona-to-persona DMs (conversations + messages), reachable from
    profiles and post cards ("Reach out").
12. AI larp assistant: "Enhance my larp" button rewrites drafts into maximum
    professional cringe. Uses Anthropic API (claude-haiku-4-5) when
    ANTHROPIC_API_KEY is set; otherwise a deterministic template-based
    cringe-ifier so the feature works with zero config.

## Stack and architecture

- Rails 8.1, Ruby 3.4.9, SQLite (prod-grade defaults), Hotwire (Turbo/Stimulus),
  Tailwind, Propshaft, importmap. No background jobs, no Action Cable pushes.
- Models: Persona, Post (+images attachments), Reaction, Comment, CommentLike,
  Connection, Endorsement, Notification, Job, JobApplication, Conversation, Message.
- Hot score computed in SQL: (reactions*3 + comments*2 + 1) / (hours_old + 2).
- Rate limits (DB count checks): 4 posts/min, 10 comments/min, 5 DMs/min,
  10 AI enhances/hour per persona; return 429 with a satirical error.
- Admin: ADMIN_TOKEN env var gates delete-any-post/persona endpoints.
- Seeds: idempotent (find_or_create_by), ~16 bot personas with hand-written
  satirical posts, jobs, and welcome-DM templates.

## Design language

LinkedIn's layout grammar (top navbar with icon nav + badge counts, 3-column feed,
cards) but a distinct palette: deep cobalt + warm paper + safety-orange accents,
so it reads "corporate network" without cloning LinkedIn blue. Mobile: single
column, bottom-sheet composer. Viewport-tested with Playwright.

## Hosting

Railway: single service built from the Rails 8 Dockerfile, volume mounted at
/rails/storage (SQLite + ActiveStorage files), RAILS_MASTER_KEY env var, domain
via Railway. Entrypoint runs db:prepare + idempotent db:seed.

## Out of scope (v2)

Real accounts, followers, search, video, editing posts, comment threads,
websocket live updates, custom OG image rendering, email.
