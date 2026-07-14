---
name: buildmine-setup
description: Set up or update the buildmine voice profile so drafts sound authentically like the user. Use when the user wants to configure buildmine, teach it their writing voice, import an existing voice/tone profile, paste example posts to learn from, or when /buildmine is run but no voice profile exists yet. Triggers on "set up buildmine", "teach buildmine my voice", "buildmine voice", "configure my posting voice".
---

# buildmine — voice setup

Your job is to produce a single file, `.claude/buildmine/voice-profile.md`, that captures how this person writes so every future draft sounds like them and not like generic AI. Do this once; it is reused on every `/buildmine` run and can be refined anytime.

## Step 1 — figure out which path the user wants

Offer three ways in (pick based on what they say; if unclear, ask once):

1. **Import** — they already have a voice/tone/brand profile (from PostMine, a brand guide, a doc, a prior `voice-profile.md`). Ask them to paste it or point to the file. Read it, then map it onto the template in Step 3, keeping their own wording where it's useful.
2. **Learn from examples** — they paste 3–10 of their real posts (from X, Threads, LinkedIn, a newsletter, anywhere). This is the highest-signal path. Analyze the examples for the dimensions in Step 2, then write the profile.
3. **Interview** — no examples handy. Ask the questions in Step 2 conversationally, a few at a time (never dump all at once). Keep it to ~6–8 questions total.

You can combine paths — e.g. import a profile *and* refine it with a couple of pasted posts.

## Step 2 — the dimensions to capture

Whichever path, the finished profile must pin down:

- **Identity & audience** — who they are, what they're building, who they're talking to (other founders? potential users? peers?).
- **Default tone** — e.g. blunt and technical, warm and reflective, hype and punchy, dry and funny. Give it in a few adjectives *and* a one-line description.
- **Sentence rhythm** — long flowing sentences vs. short staccato lines? One thought per line? Lowercase? Heavy line breaks?
- **Signature moves** — recurring hooks, framings, or structures they lean on (e.g. "I spent X hours so you don't have to", contrarian openers, before/after, numbered lessons).
- **Vocabulary** — words/phrases they actually use, and words they'd never say. Emoji: yes/no/sparingly? Hashtags: yes/no/how many?
- **Do / Don't rules** — hard rules. (e.g. "never use the word 'delve'", "no engagement-bait questions", "never fake vulnerability", "no em-dashes").
- **Hook preferences** — how they like to open a post to earn the scroll-stop.
- **Content stance** — how openly do they share struggles vs. only wins? How promotional are they willing to be?

When learning from examples, infer these and *quote a couple of real snippets* back into the profile as anchors — concrete examples steer generation better than adjectives.

## Step 3 — write the profile

Read `${CLAUDE_PLUGIN_ROOT}/templates/voice-profile.template.md` for the exact structure, fill every section from what you gathered, and write the result to `.claude/buildmine/voice-profile.md` (create the folder if needed). Keep it tight — one screen or so. It is instructions for a writer, not an essay.

## Step 4 — confirm

Show the user the finished profile, tell them it's saved, and let them know:
- moments are now being captured automatically as they build,
- they can run `/buildmine` anytime to turn recent moments into drafts,
- they can re-run this setup or just say "update my buildmine voice" to refine it (especially after they edit a draft — those edits are the best signal of their real voice).
