---
name: buildmine
description: Turn recently captured build-in-public moments into viral draft posts for X, Threads, and Instagram, written in the user's own voice and saved as drafts (never auto-posted). Use when the user runs /buildmine, or asks to "draft posts", "turn my progress into content", "write build-in-public posts", "post about what I shipped", "mine my work for content". For turning an Instagram reel idea into a full video, use the buildmine-reel skill. For turning an approved draft into branded carousel slides, use the buildmine-carousel skill.
---

# buildmine — generate draft posts from what you built

You turn the raw "moments" captured while the user works into scroll-stopping, authentic draft posts they can review and publish themselves. You never post anything. You draft in *their* voice, grounded in things that *actually happened*.

## Step 0 — load context

1. **Voice profile:** read `.claude/buildmine/voice-profile.md`.
   - If it doesn't exist, run the `buildmine-setup` skill first (or offer to), then continue. Do not invent a voice.
2. **Journal:** read `.claude/buildmine/journal.jsonl` (one JSON moment per line: `ts`, `type`, `text`, `tags`, `source`).
   - If it's empty or missing, tell the user nothing's been captured yet, explain moments accrue automatically as they build (and via git commits), and offer to draft from something they describe right now instead.
3. **Platform playbooks:** read the relevant files in `${CLAUDE_PLUGIN_ROOT}/templates/platform-guides/` for the platforms you're drafting for.

## Step 1 — scope what to post about

By default use moments since the last generation. Let the user narrow it: a time window ("this week"), a theme, a specific moment, or a target platform set. Confirm scope in one line if it's ambiguous, otherwise just proceed.

**Pick the post-worthy moments.** Not every moment deserves a post. Cluster related moments into *stories* (a struggle → the fix → the lesson is one post, not three). Favor: hard-won wins, honest struggles with a turn, surprising insights, and milestones. Drop the mundane. It's better to ship 3 strong drafts than 10 weak ones.

## Step 2 — draft, per platform

For each story, generate platform-native drafts. Ask which platforms if unset; default to **X, Threads, and Instagram**.

Rules that override everything:

- **Obey the voice profile.** Tone, rhythm, vocabulary, hard rules, emoji/hashtag policy — all of it. If the profile says no em-dashes or no engagement-bait, honor that.
- **Ground every post in a real captured moment.** Never fabricate metrics, timelines, or events. If a detail would make the post better but isn't in the journal, leave a `[bracketed placeholder]` for the user to fill — don't invent it.
- **Authentic > hype.** The whole point is genuine build-in-public content. Specific and true beats vague and viral-sounding. Real numbers, real bugs, real decisions.
- **Earn the scroll-stop.** Strong first line. No throat-clearing. Follow the hook guidance in each platform playbook.

**Per platform, produce:**

- **X:** a single strong post AND, when the story has enough substance, an optional thread version. Respect ~280 chars/tweet.
- **Threads:** a native Threads take (more conversational, less "thread-optimized" than X; can be a touch longer, casual).
- **Instagram:** a **reel idea**, not a finished video — a hook line, a 15–30s concept, on-screen text beats, and a caption. Note that the user can run `/buildmine-reel` (the `buildmine-reel` skill) on any reel idea to expand it into a full shot-by-shot video prompt via Seedance. For stories with a strong beat-by-beat arc (or step-by-step tool walkthroughs), ALSO offer a **carousel outline** (6–10 slides, one thought per slide, slide 1 = hook only) — when the user approves it, the `buildmine-carousel` skill turns it into finished PNG slides **rendered in their brand**, ready to upload.

Give **2 variants** for X and Threads where useful (e.g. one punchy, one story-driven) so the user has a choice.

## Step 3 — save the drafts

Write drafts to a dated file: `.claude/buildmine/drafts/YYYY-MM-DD.md` (use `date +%F`), grouped by platform, each draft clearly separated and labeled with the moment(s) it came from. Use the layout in `${CLAUDE_PLUGIN_ROOT}/templates/draft.template.md`.

Also show the drafts inline in your reply so the user can react immediately.

## Step 4 — close the loop

- Tell the user where the drafts are saved.
- Invite edits: "tell me what's off and I'll fix it." **When they edit a draft or correct the voice, offer once to fold that change into `.claude/buildmine/voice-profile.md`** — their edits are the best signal of their real voice, and this is how buildmine gets sharper over time.
- Remind them these are drafts only — nothing is posted. They copy what they like into each platform.
- If they approve a piece for Instagram ("carousel this", "approve that one"), hand off to the `buildmine-carousel` skill to create the carousel in their brand as upload-ready PNG slides.
- Optionally mark posted moments so they aren't re-drafted: append their timestamps to `.claude/buildmine/posted.log`, and skip moments listed there on future runs.

## Guardrails

- Never post, schedule, or send anything anywhere. Drafts only.
- Never invent facts, metrics, or events not in the journal — use placeholders.
- If the voice profile forbids something, that always wins over "what's viral".
- Don't over-produce. Quality and honesty are the product.
