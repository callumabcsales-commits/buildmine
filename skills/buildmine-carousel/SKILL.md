---
name: buildmine-carousel
description: Turn an approved buildmine draft or content piece into an Instagram carousel in the user's own brand, rendered as 1080x1350 PNG slides ready to upload. Use when the user approves a draft for a carousel ("carousel this", "make that a carousel", "approve that one", "turn this into slides") or asks for branded carousel posts from any story, tool tutorial, or draft. Never posts anything.
---

# buildmine-carousel — approved piece → branded carousel PNGs

You take ONE approved content piece (a buildmine draft, a story, a tool walkthrough) and produce a finished Instagram carousel: slide copy, brand-styled slide HTML, rendered PNGs, and a caption — saved to the user's files, ready to upload. You never post anything.

## Step 0 — load context

1. **Voice profile:** read `.claude/buildmine/voice-profile.md` — every word on every slide obeys it.
2. **Brand profile:** read `.claude/buildmine/brand-profile.md` — colors, fonts, handle, slide rules.
   - If it doesn't exist, run the brand step of `buildmine-setup` (or offer to). If the user wants to skip setup, use a neutral default (near-black/off-white, one accent they pick, serif display + sans body) and tell them slides will look generic until they add a brand profile.
3. **The piece:** identify which draft/story is approved. If ambiguous, ask which one — never guess.

## Step 1 — write the slide copy

- 6–10 slides, one thought per slide. Headlines ≤ ~12 words; support lines ≤ ~20 words. Big-type-friendly.
- **Slide 1 = hook only.** The strongest line of the piece. No setup, no context.
- Middle slides = one beat each. For tool/setup tutorials: what it is → the outcome in plain words → setup steps (one per slide, dead simple) → what to do with it first.
- Penultimate slide = the payoff/lesson.
- Final slide = CTA per the voice profile's promotional stance.
- Ground everything in the real moment/draft. `[bracket]` anything unverified — never invent.

## Step 2 — build the slides

Create `.claude/buildmine/carousels/YYYY-MM-DD-<slug>/` and write one `slide-NN.html` per slide (zero-padded).

Fill this template's CSS variables and fonts **from the brand profile** — the structure stays fixed, the tokens are theirs:

```html
<!doctype html><html><head><meta charset="utf-8"><style>
:root{
  --bg-dark:  /* brand: background (dark) */;
  --bg-light: /* brand: background (light) */;
  --ink-light:/* brand: text on light */;
  --ink-dark: /* brand: text on dark */;
  --accent:   /* brand: accent */;
  --accent-on-light: /* brand: adjusted accent, fallback = --accent only on dark */;
}
*{margin:0;box-sizing:border-box}
body{width:1080px;height:1350px;padding:90px;display:flex;flex-direction:column;
  font-family:/* brand body font */;background:var(--bg-light);color:var(--ink-light)}
body.dark{background:var(--bg-dark);color:var(--ink-dark)}
.mast{font-family:/* brand label font */;font-size:22px;text-transform:uppercase;
  letter-spacing:.08em;padding:18px 0;border-top:1px solid currentColor;border-bottom:1px solid currentColor}
.mid{flex:1;display:flex;flex-direction:column;justify-content:center;gap:40px}
h1{font-family:/* brand display font */;font-weight:400;font-size:100px;line-height:1.05}
.sub{font-size:44px;line-height:1.45;opacity:.85}
.key{border-left:3px solid var(--accent);padding-left:28px}
.accent{color:var(--accent-on-light)} body.dark .accent{color:var(--accent)}
.foot{font-family:/* brand label font */;font-size:22px;text-transform:uppercase;
  letter-spacing:.08em;display:flex;justify-content:space-between;align-items:baseline;
  padding-top:18px;border-top:1px solid currentColor}
</style></head>
<body class="dark"><!-- "dark" on cover + CTA slides only (or per brand slide rules) -->
<div class="mast"><!-- brand masthead label + date --></div>
<div class="mid">
  <h1>Hook line.</h1>
  <div class="sub key">Support line.</div>
</div>
<div class="foot"><span><!-- brand wordmark --></span><span><!-- @handle --> · 01 / 07</span></div>
</body></html>
```

Rules:
- Identical design system on every slide — only the words change.
- Shrink `h1` (down to ~80px) for long headlines rather than letting text clip.
- Respect the brand profile's contrast notes: accent-colored text on light backgrounds uses the adjusted accent; pure accent on light is for bars/rules only.
- Honor every "Never" in the brand profile's slide rules.

## Step 3 — render

```bash
bash ${CLAUDE_PLUGIN_ROOT}/bin/render-carousel.sh .claude/buildmine/carousels/<dir>
```

Then **Read one rendered PNG** to visually verify: nothing clipped, text fits, contrast holds. Fix and re-render if off.

## Step 4 — finish the package

- `caption.txt` in the carousel dir — voice-profile caption, hook front-loaded (IG truncates), CTA + hashtags per profile.
- `SOURCE.md` — the moment/draft it came from, so every claim is traceable.
- Tell the user the folder path: slides upload in filename order. Nothing is posted automatically, ever.
