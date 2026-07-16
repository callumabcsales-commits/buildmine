# buildmine

**Mine your build-in-public journey into viral draft posts — automatically, in your voice, never auto-posted.**

buildmine is a Claude Code plugin for founders and creators building with Claude. As you work, it quietly captures the moments that matter — the bug you finally killed, the feature you shipped, the insight that changed the plan — the same way Claude saves memory snippets: in the background, no ceremony. When you're ready, one command turns those real moments into scroll-stopping drafts for **X, Threads, and Instagram** — including **carousels rendered in your brand** as upload-ready slides — written to sound like *you*. Nothing ever posts on its own. You review, tweak, and publish.

It's the PostMine idea, but native to how you actually build: it mines *what you really did*, not a scrape of your landing page.

---

## How it works

Three cooperating pieces:

1. **Capture (automatic).** A `SessionStart` hook tells Claude to log build "moments" to a per-project journal as they happen. A `PostToolUse` hook also auto-logs every successful `git commit` as a shipped moment — an objective signal that never gets missed. Capture is silent and costs almost nothing.

2. **Voice.** A one-time setup builds your voice profile — by interview, by pasting a few real posts, or by importing a profile you already have. Every draft obeys it.

3. **Generate (on demand).** Run `/buildmine` and it reads your recent moments + voice profile + platform playbooks, clusters them into stories, and writes platform-native drafts. Instagram comes out as a **reel idea** you can expand into a full video with `/buildmine-reel`, plus a **carousel outline** when the story has a beat-by-beat arc.

4. **Carousels, in your brand.** The setup interview also captures a small brand profile (colors, fonts, handle). Approve any draft ("carousel this") and the `buildmine-carousel` skill writes the slide copy, styles it with *your* brand tokens, and renders finished **1080×1350 PNG slides** into your files — ready to upload, never posted for you. (Rendering uses headless Chrome/Chromium.)

Everything lives in your project under `.claude/buildmine/`, so it's genuinely project-scoped — a different project keeps its own journal, voice, and drafts.

```
.claude/buildmine/
├── journal.jsonl        # captured moments (auto)
├── voice-profile.md     # how you write (from setup)
├── brand-profile.md     # how your carousels look (from setup, optional)
├── drafts/YYYY-MM-DD.md # generated drafts
├── carousels/           # rendered carousel PNGs + captions, ready to upload
└── posted.log           # optional: moments already published
```

---

## Install

**Local (try it now):**
```bash
claude --plugin-dir /path/to/buildmine
```

**Via a marketplace (for sharing):** add the repo hosting this plugin as a marketplace, then `/plugin install buildmine`.

Requires `python3` **or** `node` on your machine (used only to write journal lines safely) — both are standard on dev machines.

---

## Use it

1. **Set up your voice once:**
   ```
   /buildmine-setup
   ```
   Interview, paste example posts, or import an existing profile.

2. **Just build.** Moments capture themselves as you work and commit.

3. **Draft when you want:**
   ```
   /buildmine
   ```
   Get X posts, Threads posts, and an Instagram reel idea — saved to `.claude/buildmine/drafts/` and shown inline.

4. **Expand a reel:**
   ```
   /buildmine-reel
   ```
   Turns a reel idea into a full shot-by-shot video prompt (via the `seedance-2-video-prompt` skill).

5. **Approve a carousel:** say **"carousel this"** on any draft — slide copy gets written, styled in your brand, and rendered as PNG slides in `.claude/buildmine/carousels/<date>-<slug>/` with a caption. Upload in filename order.

6. **Refine.** Edit any draft and tell Claude what was off — it offers to fold your changes back into your voice profile, so drafts get more *you* over time.

---

## Manual capture

Claude captures moments for you, but you can log one yourself anytime:

```bash
.claude/buildmine/../bin/buildmine-capture --type win --text "shipped the onboarding flow" --tags onboarding
```

Types: `win` · `ship` · `milestone` · `insight` · `struggle`.

---

## Principles

- **Authentic over hype.** Real bugs, real numbers, real decisions. It never invents metrics or events — anything missing becomes a `[placeholder]` for you to fill.
- **Drafts only.** buildmine never posts, schedules, or sends anything. Ever.
- **Your voice wins.** If your profile says "no em-dashes" or "no engagement-bait", that beats whatever's trending.
- **Project-scoped.** Each project has its own journal, voice, and drafts.

---

## Layout

```
buildmine/
├── .claude-plugin/plugin.json
├── hooks/hooks.json
├── bin/
│   ├── buildmine-capture              # append a moment to the journal
│   ├── buildmine-capture-hook.sh      # PostToolUse: auto-log git commits
│   ├── buildmine-session-start.sh     # SessionStart: turn on background capture
│   └── render-carousel.sh             # slide HTML → 1080×1350 PNGs (headless Chrome)
├── skills/
│   ├── buildmine/SKILL.md             # /buildmine — generate drafts
│   ├── buildmine-setup/SKILL.md       # /buildmine-setup — voice + brand profiles
│   ├── buildmine-reel/SKILL.md        # /buildmine-reel — reel idea → video
│   └── buildmine-carousel/SKILL.md    # approved draft → branded carousel PNGs
└── templates/
    ├── voice-profile.template.md
    ├── brand-profile.template.md
    ├── draft.template.md
    └── platform-guides/{x,threads,instagram}.md
```

MIT.
