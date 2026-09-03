# Isabela Manelici Website — Design Decisions

**Goal:** reproduce the look and content of Isabela Manelici's current Wix-hosted site (https://www.isabelamanelici.com) in the repo `isabelamanelici.github.io`, deployed for free via GitHub Pages.

**Grilled:** 2026-04-17.

---

## Key Facts (reconnaissance)

- Current live site is built on **Wix** (`<meta name="generator" content="Wix.com Website Builder"/>`). No clean source available — only rendered output.
- Target repo `isabelamanelici.github.io` is currently empty (everything erased in commit `c5c6cb7`).
- Jose's own site `jpvasquez-econ.github.io` uses the **academicpages** Jekyll template — Jose is comfortable maintaining it.
- Isabela owns a GitHub account (username needs verification — must be exactly `isabelamanelici` for the `*.github.io` URL to work).
- Isabela is willing to retire the Wix site after the new one launches.

---

## Decisions

| # | Branch | Decision | Rationale |
|---|---|---|---|
| 1 | **Stack** | Jekyll / academicpages, hosted on GitHub Pages | Jose is familiar; standard for economist sites; repo name already follows Jekyll convention; free; no build pipeline |
| 2 | **Visual fidelity level** | **L2 — Visually close** | ~95% of the fidelity at a fraction of L3 effort; pixel-perfect on Wix is a diminishing-returns trap |
| 3 | **Page structure** | **3C — Single page** (landing shows everything) backed by academicpages data files under the hood | Matches Wix UX; but `_publications/` markdown files keep content easy to update |
| 4 | **Starting point** | **4B — Fresh academicpages fork** | Clean provenance, no risk of Jose's content leaking in |
| 5 | **Deployment / URL** | `https://isabelamanelici.github.io`; Isabela's GitHub account; both Jose and Isabela push to `main`; free GitHub Pages | No custom domain for now |
| 6 | **Design token extraction** | **6A — Manual DevTools inspection** (NOT the ai-website-cloner-template) | Cloner is overkill for a small site; manual is faster and more reliable on Wix JS-rendered output |
| 7 | **PDF folder** | `/files/` at repo root; keep local filenames as-is | academicpages convention; stable URLs like `/files/CV_Manelici.pdf` |
| 8 | **Images** | **8C — Official LSE SVG from brand portal + Isabela's original headshot**; fallback to Wix copies meanwhile | Higher quality; clean licensing |
| PDFs addendum | **PDFs** | Same pattern as images: use Wix copies as placeholders, swap to Isabela's originals when provided | |
| 9 | **Content source** | **9A — Scrape from Wix verbatim**, no pre-launch review gate | Unblocks everything; Isabela can correct post-launch |
| 10 | **Navigation** | **10-i — No top nav; pure single-page scroll** | Matches economist-site norm; avoids mimicking Wix's "More" tab quirk |
| 11a | **Local preview** | Install Ruby + Bundler + Jekyll; use `bundle exec jekyll serve` | Catch errors before pushing |
| 11b | **Git workflow** | Direct commits to `main`, no PRs | Two-person site, low churn |
| 11c | **Custom domain (CNAME)** | Skip for now; launch at `isabelamanelici.github.io` | Isabela willing to retire Wix; can add CNAME later if she migrates `isabelamanelici.com` DNS |
| 11d | **Analytics** | None | Privacy-friendly; no moving parts |
| 11e | **Favicon** | Wix copy as placeholder | Same fallback pattern |
| 11f | **SEO** | Basic meta tags via `jekyll-seo-tag` | Free via academicpages |
| 11g | **Research focus keywords** | Preserve exactly ("International Economics, Economic Development, Firm Organisation") | Part of verbatim scrape |
| 11h | **ERC Starting Grant announcement** | Include as on Wix | Part of verbatim scrape |

---

## Explicitly NOT doing

- Not using `ai-website-cloner-template` (not even its recon phase).
- Not producing a Next.js project.
- Not building a multi-page layout with separate `/publications/`, `/cv/`, `/teaching/` URLs.
- Not adding a top tab nav with "More" dropdown.
- Not adding Google Analytics.
- Not registering `isabelamanelici.com` CNAME yet.
- Not pre-launching with Isabela review gate on content.

---

## Site content inventory (from Wix scrape, to be expanded in the plan)

**Sections (top-to-bottom on Home):**
1. Header (site title)
2. Profile photo
3. LSE logo
4. Intro (name + Assistant Professor, LSE)
5. ERC Starting Grant 2025-2030 (LINK4DEV) announcement
6. Affiliations list: CEP, CEPR, CESifo, IGC, POID, RFBerlin, STICERD
7. CV + Google Scholar links
8. Research focus: "International Economics, Economic Development, Firm Organisation"
9. Contact: i.manelici@lse.ac.uk
10. PhD admissions note
11. Research
    - Working Papers (3 listed)
    - Peer-Reviewed Publications (3 listed)
    - Other Publications (4 items: WTO reports, VoxDev, etc.)

**Assets:**
- 9 PDFs scraped from Wix (opaque hashed filenames like `c7b5dd_3b42cc38...pdf`) — Jose has readable-named local copies to drop in.
- Headshot (Wix-downsampled copy as fallback).
- LSE logo (will use official SVG from LSE brand portal).

**External links to preserve:**
- LSE Economics Department, CEP, CEPR, CESifo, IGC, POID, RFBerlin, STICERD institutional pages
- Google Scholar profile
- Trade Talks podcast (2 episodes)
- VoxDev/VoxEU summaries
- NBER paper links
- Journal articles (QJE, EER, JUE)
- Alfaro-Ureña collaborator page
- LSE Business Review article
- 2024 WTO Trade Report
- YouTube presentation recording

---

## Open items / needs Isabela

1. ~~Confirm her GitHub username is exactly `isabelamanelici`~~ ✅ **Confirmed 2026-04-17**: username is `isabelamanelici`.
2. Provide original high-res headshot JPEG (Wix downsample used meanwhile).
3. Provide final PDF versions (Wix copies used meanwhile).
4. Post-launch content review pass (fix any scraping errors).
5. Eventually: decide on CNAME / DNS migration of `isabelamanelici.com` and Wix shutdown date.

---

## Handoff

Next step: `/ce:plan` generates the implementation plan off this decisions doc.
