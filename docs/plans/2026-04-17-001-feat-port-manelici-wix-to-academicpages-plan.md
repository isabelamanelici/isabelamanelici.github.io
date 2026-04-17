---
title: Port Isabela Manelici's Wix site to academicpages Jekyll
type: feat
status: active
date: 2026-04-17
origin: docs/planning/decisions.md
deepened: 2026-04-17
reviewed: 2026-04-17 (DHH / simplicity / architecture — findings applied)
---

# Port Isabela Manelici's Wix site to academicpages Jekyll

## Enhancement Summary

**Deepened & reviewed on:** 2026-04-17.
**Research agents used:** Jekyll/GitHub-Pages best-practices, academic-SEO, performance-oracle, code-simplicity, a11y, framework-docs.
**Technical reviewers:** DHH-style, Simplicity, Architecture-strategist.

### Major changes from first draft

1. **Pinned all versions** (Ruby 3.3.4, Jekyll 3.10.0, `github-pages` v232, academicpages v0.8.4).
2. **Fixed a silent-failure gotcha**: GitHub Pages now defaults new repos to "GitHub Actions" source. Phase 8.4 explicitly switches to "Deploy from a branch" — without this the site 404s.
3. **Trimmed Phase 2** (was 6 tasks, now 4) — dropped the 9-PDF curl loop and LSE-logo download; both were "insurance theater" given Jose has local copies.
4. **Moved optional Scholar SEO out** → [docs/plans/future-scholar-seo.md](future-scholar-seo.md). Core MVP stays focused.
5. **Picked ONE publications architecture** (DHH): hardcoded inline in `_pages/main.md`. Empty `_publications/`, `_talks/`, `_teaching/`, `_posts/` directories are deleted — no participation-trophy dirs.
6. **Softened Phase 6 Ruby install**: try `ruby -v` first; only install rbenv if that fails.
7. **Image-optimization commands** baked into Phase 4 (concrete `sips`/`pngquant` with byte targets).
8. **Accessibility** baked into markup: `alt=""` on headshot (name is adjacent), h1→h2 hierarchy, "(PDF)" in link text.
9. **Dropped** grep/curl verification loops. A non-developer clicking through the local preview catches issues faster than shell regex.

### Decision trade-off flagged

Decision 3C in `decisions.md` called for "single-page display backed by `_publications/` data files." This revised plan implements pure single-page (3B-ish) with hardcoded inline content. Reason: for ~10 papers updated annually by a non-developer, one markdown file is simpler than 10 YAML-fronted files + Liquid loop. Scholar-indexing benefit of 3C is deferred to `future-scholar-seo.md`. If this trade-off is wrong, revert before starting Phase 3.

---

## Overview

Rebuild `https://www.isabelamanelici.com` (currently Wix) as a Jekyll/academicpages site deployed free via GitHub Pages at `https://isabelamanelici.github.io`. The target repo at `/Users/j.p.vasquez/Library/CloudStorage/Dropbox/Academic Sharing Isa-JP/Research and pupici/isabelamanelici.github.io/` is currently empty. Strategic decisions live in [docs/planning/decisions.md](../planning/decisions.md). Verbatim Wix content frozen in [docs/planning/wix-content-snapshot.md](../planning/wix-content-snapshot.md).

Fidelity target: **L2** (visually close, not pixel-perfect).
Deployment target: `https://isabelamanelici.github.io` (Isabela's account `isabelamanelici`, confirmed).

## Technical Approach

- **Stack:** Jekyll 3.10.0 (pinned by `github-pages` gem v232) on academicpages v0.8.4, hosted on GitHub Pages.
- **Content:** single landing page `_pages/main.md` with inline markdown. No `_publications/`, `_talks/`, `_teaching/`, `_posts/` — deleted as YAGNI.
- **Styling:** small override block in `assets/css/main.scss` applied after live DevTools inspection of Wix.
- **Deploy:** `git push origin main` → GitHub Pages Jekyll builder → live URL. No Actions workflow.

---

## Implementation Phases

### Phase 1 — Scaffold academicpages into the empty repo (~15 min)

- [x] **1.1** `cd "/Users/j.p.vasquez/Library/CloudStorage/Dropbox/Academic Sharing Isa-JP/Research and pupici/isabelamanelici.github.io/"`
- [x] **1.2** `ls -la` — confirm only `.git`, `.DS_Store`, and `docs/` present. If anything else, stop and investigate.
- [x] **1.3** Tarball-overlay academicpages v0.8.4:
  ```bash
  curl -L https://github.com/academicpages/academicpages.github.io/archive/refs/tags/v0.8.4.tar.gz | tar xz --strip-components=1
  rm -rf .github
  rm -f CNAME
  ```
- [x] **1.4** Delete empty demo collections (DHH — no participation trophies):
  ```bash
  rm -rf _publications _talks _teaching _posts
  ```
  These can always be re-added later if we ever execute `future-scholar-seo.md`.
- [x] **1.5** Commit:
  ```bash
  git add -A
  git commit -m "feat: scaffold academicpages v0.8.4 template baseline"
  ```

---

### Phase 2 — Snapshot the Wix site before retirement (~5 min, TIME-SENSITIVE)

Only what's actually load-bearing: headshot (we'll compress in Phase 4) + HTML snapshot (used in Phase 5 for link extraction).

- [x] **2.1** `mkdir -p files images docs/planning/wix-archive`
- [x] **2.2** Download original-resolution headshot (1.1 MB, 3170×2910).
- [x] **2.3** Save HTML snapshot for link extraction (360 KB).
- [x] **2.4** Commit.

---

### Phase 3 — Personalize `_config.yml` and write `_pages/main.md` (~30 min)

- [x] **3.1** Edit `_config.yml`:
  - `title:` → `"Isabela Manelici"`
  - `name: &name` → `"Isabela Manelici"`
  - `description:` → `"Personal website of Isabela Manelici — research in international trade, foreign direct investment, and labor economics."`
  - `url:` → `"https://isabelamanelici.github.io"`
  - `repository:` → `"isabelamanelici/isabelamanelici.github.io"`
  - `author:` block:
    - `email: "i.manelici@lse.ac.uk"`
    - `bio: "Assistant Professor of Economics, LSE"`
    - `location: "London, UK"`
    - `googlescholar: "https://scholar.google.com/citations?user=XYTdVRAAAAAJ&hl=en"`
    - `employer: "London School of Economics"`
  - `google_analytics:` → blank (decision 11d).
- [x] **3.2** Replace `_pages/about.md` with `_pages/main.md` (accessibility baked in: `alt=""`, `<h1>` for name, `<h2>` for sections, "(PDF)" link text). Also deleted demo pages (cv.md, portfolio.html, publications.html, talks.html, teaching.html, archive templates) since we have no nav; only `404.md` and `sitemap.md` remain alongside `main.md`.
  ```markdown
  ---
  permalink: /
  title: ""
  excerpt: ""
  author_profile: true
  ---

  <img class="img-responsive" style="float: left; margin: 7px 20px 0px 0px;" src="/images/headshot.jpg" width="220" alt="">

  # Isabela Manelici

  Welcome to my website! I am an Assistant Professor in the [Department of Economics](https://www.lse.ac.uk/economics) of the [London School of Economics and Political Science](https://www.lse.ac.uk). I was awarded a 2025-2030 ERC Starting Grant for ["LINK4DEV: Can Multinational Linkages Be Leveraged for Development?"](#).

  I am affiliated with the [CEP](https://cep.lse.ac.uk) (Centre for Economic Performance, Trade and Urban), [CEPR](https://cepr.org/research/programme-areas/international-trade-and-regional-economics) (International Trade and Regional Economics), [CESifo](https://www.cesifo.org/en/research-network-area/global-economy) (Global Economy Area), [IGC](https://www.theigc.org/) (International Growth Center), [POID](#) (Programme on Innovation and Diffusion), [RFBerlin](#) (ROCKWOOL Foundation Berlin), and [STICERD](#) (Suntory & Toyota International Centres for Economics).

  [**Curriculum Vitae** (PDF)](/files/CV_Manelici.pdf) · [**Google Scholar**](https://scholar.google.com/citations?user=XYTdVRAAAAAJ&hl=en)

  **Focus:** International Economics, Economic Development, Firm Organisation.

  **Email:** <i.manelici@lse.ac.uk>

  Note on Ph.D. admissions, RA and postdoc opportunities: [read the note (PDF)](/files/PhD_Note.pdf).

  ---

  ## Working papers

  - [<u>**Responsible Sourcing? Evidence from Costa Rica**</u>](/files/Responsible_Sourcing_CR.pdf) — NBER WP 30683, with [Alonso Alfaro-Ureña](https://sites.google.com/view/alfarourena/home), [Benjamin Faber](#), [Cecile Gaubert](#), and [José P. Vasquez](#). *Second round Revise-and-Resubmit at the American Economic Review* ([Trade Talks](#) · [VoxDev](#) · [VoxEU](#)).
  - [<u>**The Gains from Foreign Multinationals in an Economy with Distortions**</u>](#) with Mauricio Ulate, José P. Vasquez and Román David Zárate. *Draft available upon request.*
  - [<u>**The Effects of Multinationals on Workers: Evidence from Costa Rican Microdata**</u>](/files/Effects_MNC_Workers.pdf) with Alonso Alfaro-Ureña and José P. Vasquez. *New draft in progress.* ([ReVista article](#))

  ## Peer-reviewed publications

  - [<u>**The Effects of Joining Multinational Supply Chains: New Evidence from Firm-to-Firm Linkages**</u>](/files/Effects_of_Joining_MNC_Supply_Chains_QJE.pdf) with Alonso Alfaro-Ureña and José P. Vasquez. *Quarterly Journal of Economics*, 137(3), Aug. 2022, 1495–1552 ([Online Appendix](/files/JoiningMNC_OnlineAppendix.pdf)). Media: [VoxDev](#) · [IGC](#) · [The Visible Hand podcast](#) · [Faculti interview](#) · [LSE Business Review](#).
  - [<u>**Industrial Policy at Work: Evidence from Romania's Income Tax Break for Workers in IT**</u>](/files/IndustrialPolicy_EER.pdf) with Smaranda Pantea. *European Economic Review*, 133, Apr. 2021 ([Online Appendix](/files/IndustrialPolicy_OnlineAppendix.pdf)). Media: [Trade Talks](#) · [VoxEU](#) · [Presentation recording](#).
  - [<u>**Terrorism and the Value of Proximity to Public Transportation: Evidence from the London Bombings**</u>](/files/Terrorism_JUE.pdf). *Journal of Urban Economics*, 102, Nov. 2017, 52-75.

  ## Other publications

  - London Consensus response to Ricardo Hausmann's chapter on "Export-Led Growth". *London Consensus, Economic Principles for the 21st Century.* Edited by Tim Besley, Irene Bucelli and Andrés Velasco. LSE Press, October 2025.
  - VoxDevLit on ["International Trade"](#) (with Atkin, Boudreau, Dix-Carneiro, Khandelwal, McCaig, Medina, Morjaria, Pascali, Pellegrina, Rijkers, and Startz). VoxDevLit, 4(2), February 2025.
  - VoxDevLit on ["Foreign Direct Investment and Development"](#) (with Alviarez, Boudreau, Dardati, Fan, Farrokhi, Garcia-Lembergman, Garetto, Gu, Hale, Hemous, Limodio, Martin, Morales, Pandalai-Nayar, Pavcnik, Pellegrina, Ramondo, Vasquez, and Vezina). VoxDevLit, 13(1), February 2025.
  - 2024 WTO Trade Report on ["Trade and Inclusiveness"](#). Opinion Piece on "The Promise and Pitfalls of Responsible Sourcing in Global Value Chains", page 133 (with Alfaro-Ureña, Faber, Gaubert, and Vasquez).
  ```
- [x] **3.3** `rm -f _pages/about.md` — replaced by `main.md`.
- [x] **3.4** Committed as `b15b1e0`.

---

### Phase 4 — Drop PDFs and optimize images (~30 min, Jose action)

- [ ] **4.1** Jose places the 9 local PDFs into `files/`. Expected filenames (update `_pages/main.md` if Jose uses different names):
  ```
  files/CV_Manelici.pdf
  files/Responsible_Sourcing_CR.pdf
  files/Effects_MNC_Workers.pdf
  files/Effects_of_Joining_MNC_Supply_Chains_QJE.pdf
  files/JoiningMNC_OnlineAppendix.pdf
  files/IndustrialPolicy_EER.pdf
  files/IndustrialPolicy_OnlineAppendix.pdf
  files/Terrorism_JUE.pdf
  files/PhD_Note.pdf
  ```
- [ ] **4.2** Optimize headshot (macOS built-in `sips`, no install needed):
  ```bash
  sips -Z 440 docs/planning/wix-archive/headshot_wix_original.jpg \
       --setProperty formatOptions 82 \
       --out images/headshot.jpg
  ls -lh images/headshot.jpg  # expect < 100 KB
  ```
- [ ] **4.3** LSE logo — skipped for now. Placeholder = no image. Phase 9 handoff item asks Isabela for official SVG.
- [ ] **4.4** Commit:
  ```bash
  git add files/ images/
  git commit -m "feat: add Isabela's PDFs and optimized headshot"
  ```

---

### Phase 5 — Fill in external links (~20 min)

- [ ] **5.1** Open `docs/planning/wix-archive/wix_snapshot.html` in a browser. For each `(#)` in `_pages/main.md`, paste the real URL from the Wix HTML. Work section-by-section.
- [ ] **5.2** Commit:
  ```bash
  git add _pages/main.md
  git commit -m "feat: populate external links"
  ```

---

### Phase 6 — Local preview with Jekyll (~30 min first-time; ~1 min thereafter)

- [ ] **6.1** Check current Ruby:
  ```bash
  ruby -v
  ```
  If it shows Ruby 3.x (any 3.x works with `github-pages` gem), skip to 6.3. If older or not present, continue.
- [ ] **6.2** (If needed) Install Ruby 3.3.4 via rbenv:
  ```bash
  brew install rbenv ruby-build
  rbenv install 3.3.4
  rbenv global 3.3.4
  eval "$(rbenv init -)"  # add to ~/.zshrc permanently
  ```
- [ ] **6.3** Install bundler and gems:
  ```bash
  gem install bundler
  cd "/Users/j.p.vasquez/Library/CloudStorage/Dropbox/Academic Sharing Isa-JP/Research and pupici/isabelamanelici.github.io/"
  bundle install
  ```
  On permission errors: `bundle config set --local path 'vendor/bundle' && bundle install` (add `vendor/` to `.gitignore`).
- [ ] **6.4** Verify the build works without any warnings:
  ```bash
  bundle exec jekyll build
  ```
  This catches plugin / YAML errors that `serve` might mask. If errors, fix before proceeding.
- [ ] **6.5** Start preview:
  ```bash
  bundle exec jekyll serve -l
  ```
  Open http://localhost:4000.
- [ ] **6.6** Smoke-test:
  - [ ] Bio renders
  - [ ] Headshot visible
  - [ ] All paper titles present
  - [ ] Click every PDF link — downloads
  - [ ] Click every external link — correct destination
  - [ ] No 404s in the Jekyll terminal
- [ ] **6.7** Ctrl+C. Commit:
  ```bash
  git add Gemfile.lock
  git commit -m "chore: lock Ruby gem versions"
  ```

---

### Phase 7 — Apply L2 visual styling (~2-4 hours, iterative)

- [ ] **7.1** Open Wix in one browser window with DevTools; `assets/css/main.scss` in editor. Use ⌘⇧C to inspect elements on Wix and read computed values.
- [ ] **7.2** Add a starter 3-override block at the end of `main.scss` (after `@import`s). Replace `<X>` with computed values:
  ```scss
  /* Isabela Manelici — L2 fidelity to Wix */
  .page__content h1,
  .page__content h2 {
      color: #<WIX_HEADING_HEX>;   /* e.g. #7E0024 LSE wine */
      border-bottom: none;
  }

  a {
      color: #<WIX_LINK_HEX>;
  }

  .page {
      max-width: <WIX_MAX_WIDTH>;  /* e.g. 900px */
      margin: 0 auto;
  }
  ```
- [ ] **7.3** Ctrl+C Jekyll, restart `bundle exec jekyll serve -l`. SCSS sometimes needs a hard restart.
- [ ] **7.4** Squint test: localhost vs live Wix side-by-side. Close your eyes, open briefly — same site? Add overrides one at a time only if needed: typography, background color, heading weight, image shadow, dividers.
- [ ] **7.5** Mobile check via DevTools device toolbar.
- [ ] **7.6** Commit each meaningful iteration:
  ```bash
  git add assets/css/main.scss
  git commit -m "style: L2 fidelity — [what changed]"
  ```

Color contrast note: LSE wine `#7E0024` and navy `#15317E` both pass WCAG AAA on white. Never combine them as fg/bg (1.08:1 — invisible).

---

### Phase 8 — Deploy to `isabelamanelici.github.io` (~30 min)

- [ ] **8.1** Pre-flight: confirm Isabela's GitHub account exists and has the repo:
  ```bash
  curl -sI https://github.com/isabelamanelici/isabelamanelici.github.io | head -1
  # Expect HTTP/2 200
  ```
  If 404: Isabela needs to create the repo under her account (empty, public).
- [ ] **8.2** Point the local repo at the remote:
  ```bash
  git remote -v
  # If origin missing or wrong:
  git remote set-url origin https://github.com/isabelamanelici/isabelamanelici.github.io.git
  ```
- [ ] **8.3** Push access: Isabela invites Jose as collaborator (Settings → Collaborators → Add people → Jose's GitHub username). Jose accepts via email. Verify:
  ```bash
  git push --dry-run origin main
  ```
- [ ] **8.4** Push:
  ```bash
  git push origin main
  ```
- [ ] **8.5** ⚠️ **Critical**: enable GitHub Pages. Go to `https://github.com/isabelamanelici/isabelamanelici.github.io/settings/pages`:
  - Source: **Deploy from a branch** ← the new default is "GitHub Actions"; this MUST be changed
  - Branch: **main** · folder **/ (root)**
  - Save.

  Without this the site silently returns 404.
- [ ] **8.6** After ~2 min, visit `https://isabelamanelici.github.io`:
  - [ ] Page loads
  - [ ] All sections render
  - [ ] All 9 PDFs downloadable
  - [ ] Headshot visible
- [ ] **8.7** Troubleshoot via the Actions tab if build fails. Usually a YAML frontmatter issue; `bundle exec jekyll build` locally would have caught it (Phase 6.4).
- [ ] **8.8** Add a README with edit instructions for Isabela:
  ```bash
  cat > README.md <<'EOF'
  # isabelamanelici.github.io

  Personal website of Isabela Manelici.
  Built with Jekyll + academicpages. Hosted free on GitHub Pages.

  ## Edit content

  - **Bio, papers, links:** `_pages/main.md`
  - **PDFs:** drop into `files/`, reference as `/files/filename.pdf`
  - **Photos:** replace `images/headshot.jpg`
  - **Styling:** `assets/css/main.scss`

  Editing via GitHub web UI: click the file, pencil icon, edit, "Commit changes".
  Site rebuilds in 1-2 minutes.

  ## Local preview

      bundle install
      bundle exec jekyll serve -l
      open http://localhost:4000
  EOF

  git add README.md
  git commit -m "docs: add README with edit + publish instructions"
  git push origin main
  ```

---

### Phase 9 — Handoff to Isabela (~15 min)

- [ ] **9.1** Email Isabela:
  - Live URL: `https://isabelamanelici.github.io`
  - Wix + new site live in parallel; retire Wix whenever ready
  - To-provide list:
    - Original high-res headshot JPEG (replace `images/headshot.jpg`)
    - Official LSE SVG from [LSE brand portal](https://info.lse.ac.uk/staff/divisions/communications-division/brand-and-identity) if she wants the logo displayed
    - Real URL for the ERC Starting Grant "LINK4DEV" link (currently `#` placeholder)
  - Instructions: any paper update = edit `_pages/main.md` via GitHub web UI → commit → wait 2 min.
- [ ] **9.2** Short screen-share: walk her through one edit cycle.
- [ ] **9.3** Append remaining follow-up items to `docs/planning/decisions.md`.

---

## Acceptance Criteria

### Functional

- [ ] `https://isabelamanelici.github.io` loads and matches `wix-content-snapshot.md`.
- [ ] All 9 PDFs downloadable.
- [ ] All external links resolve.

### Non-functional

- [ ] Squint test passes against Wix.
- [ ] Mobile usable.
- [ ] `images/headshot.jpg` < 100 KB.

### Accessibility

- [ ] One `<h1>` (her name), `<h2>` for sections.
- [ ] Headshot `alt=""` (name is adjacent).
- [ ] PDF links announce "(PDF)".
- [ ] WCAG AA color contrast (LSE wine + navy on white both pass AAA).

### Quality gates

- [ ] `bundle exec jekyll build` exits cleanly.
- [ ] No `(#)` placeholders remain in `_pages/main.md`.

## Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| GitHub Pages "Source" left on Actions default → site 404s | **High** (easy to miss) | Phase 8.5 explicitly switches to "Deploy from a branch". |
| Wix retires before Phase 2 completes | Low | Phase 2 runs first, ~5 min. |
| Ruby setup fails on macOS | Medium | Phase 6.1 checks existing Ruby first; 6.2 fallback to rbenv. |
| Uncompressed headshot blows page weight | Medium | Phase 4.2 enforces < 100 KB via `sips`. |
| Isabela's GitHub repo doesn't exist | Low | Phase 8.1 pre-flight curl check. |

## Sources

- [academicpages canonical repo v0.8.4](https://github.com/academicpages/academicpages.github.io)
- [GitHub Pages versions manifest](https://pages.github.com/versions/)
- [GitHub Pages Jekyll docs](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll)
- [WebAIM: Alternative Text](https://webaim.org/techniques/alttext/)
- [decisions.md](../planning/decisions.md)
- [wix-content-snapshot.md](../planning/wix-content-snapshot.md)
- [future-scholar-seo.md](future-scholar-seo.md) — deferred SEO polish

## Related: deferred work

- [`docs/plans/future-scholar-seo.md`](future-scholar-seo.md) — Google Scholar `citation_*` meta tags, per-paper pages, robots.txt, OG preview image. Execute post-launch if Isabela wants it.
