---
name: buildmine-reel
description: Expand a buildmine Instagram reel idea into a full, generation-ready video. Use when the user runs /buildmine-reel, or says "make the reel", "turn this reel idea into a video", "expand this into a shot list", "generate the video for this reel". Takes a short reel concept (from a buildmine draft or described directly) and produces a structured video prompt, handing off to the seedance-2-video-prompt skill.
---

# buildmine — expand a reel idea into a video

The `buildmine` skill produces Instagram **reel ideas** (a hook, a concept, on-screen text beats, a caption). This skill takes one of those ideas and turns it into a full, shot-by-shot, generation-ready video prompt.

## Step 1 — get the reel idea

- If the user pointed at a specific draft, read it from `.claude/buildmine/drafts/` and pull that reel idea.
- If they described one inline, use that.
- If ambiguous, show the reel ideas from the most recent drafts file and ask which one.

Also pull the relevant source moment(s) from `.claude/buildmine/journal.jsonl` and the `.claude/buildmine/voice-profile.md` so the video's on-screen copy and vibe stay true to the user and to what actually happened. Never fabricate metrics or events — carry over only what's real; use `[placeholders]` for anything missing.

## Step 2 — shape the brief

Turn the reel idea into a tight creative brief before generating:

- **Core message** (one line) — the single thing a viewer should take away.
- **Hook** — the first ~1.5 seconds; must stop the scroll.
- **Format** — talking-head-with-b-roll, screen-recording-driven, text-on-motion, day-in-the-life, before/after, etc. Pick what fits a build-in-public founder and what's actually producible.
- **On-screen text beats** — timed, from the reel idea.
- **Pace, mood, music feel** — match the voice profile's tone.
- **Aspect ratio** — 9:16 vertical for reels.
- **Length** — typically 15–30s.

## Step 3 — hand off to Seedance

Invoke the **seedance-2-video-prompt** skill with this brief to produce the structured, shot-by-shot video prompt. That skill owns the output format for Seedance 2.0; let it drive. Pass along the core message, hook, format, on-screen beats, mood, aspect ratio, and length.

If that skill isn't available in the environment, fall back to producing a clear shot list yourself: numbered shots with duration, visual, camera move, on-screen text, and audio/VO per shot — plus the final caption.

## Step 4 — deliver

Return the finished video prompt / shot list, and remind the user it pairs with the caption from their reel draft. As always: nothing is posted — this is theirs to generate and publish.
