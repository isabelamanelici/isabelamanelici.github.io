---
title: Restructure repo so Isabela only ever touches main.md
type: refactor
status: active
date: 2026-09-03
origin: grilling session 2026-09-03 (transcript in Section 2)
executor: /ce-work-codex
---

# Restructure repo so Isabela only ever touches main.md

## Section 1 — Originating prompt

> In the meantime (if possible). Isabela is not familiar with how to use the website. To make it easier for her, I want the repo to have three folders: `files/`, `images/`, and one called `everything_else/`. Then outside in the root the `main.md` file, which is the one she would have to modify. `/grilling` then `/compound-engineering:ce-plan` then `/ce-work-codex`.

Context at time of request: repo `isabelamanelici/isabelamanelici.github.io`, HEAD `f07605a` on `main`, synced with origin. Site built by GitHub Pages' native Jekyll build from branch `main` root. Custom domain `www.isabelamanelici.com` connected today (Wix DNS → GitHub IPs; CNAME file committed by GitHub); HTTPS certificate still pending. Jose's shell has no GitHub credentials (pushes go through VS Code). Isabela is repo owner; Jose is a non-admin collaborator.

## Section 2 — Grilling transcript

**Q1. How much new build machinery are you willing to take on to get the clean root?**
Options: GitHub Actions build (workflow stages everything_else/ + files/ + images/ + main.md into a build dir, runs jekyll-build-pages, deploys; root = 4 items + .github/; Pages source switches to Actions; new moving part; ~1–2 min build per edit; build failures show in Actions tab) / Keep native build, tidy instead (no workflow; internals stay at root; README says "edit main.md only"; root still shows ~15 Jekyll dirs) / Two repos (content repo she edits; build repo pulls and deploys; cleanest view, most plumbing).
Answer: **GitHub Actions build**

**Q2. With an Actions build, a broken edit by Isabela (e.g. stray characters in main.md front matter) makes the build fail silently: the old site stays live and GitHub emails the repo owner (her). Who should catch that?**
Options: Her, via GitHub's default email / You, explicitly (workflow notifies Jose on failure) / Prevent it: lock front matter (move title/permalink out of main.md into _config.yml defaults so main.md is pure Markdown).
Answer: **Prevent it: lock front matter**

**Q3 (first framing). Locking front matter removes one hazard, but the body itself is heavy HTML. When Isabela adds a new paper next year, what does she copy-paste?**
Options: Keep HTML blocks as-is / Convert papers to plain Markdown / Papers in a YAML data file.
Answer: "I don't understand. The main.md is very simple"

*(Claude showed the actual `<p class="pub">` HTML of one paper entry from `_pages/main.md:42-46` and re-asked.)*

**Q3 (second framing). When Isabela adds a paper, what does she edit?**
Options: Copy an HTML `<p class="pub">` block (status quo; identical look; missed closing tag garbles page) / Copy a Markdown block (papers rewritten as Markdown; CSS retuned; needs restyle + visual check) / Leave format decision to you/Jose later (restructure folders now, content byte-identical).
Answer: **Copy a Markdown block**

**Q4. Where should the logo/headshot header block live?** (consistency check on "Markdown": header is HTML with inline pixel sizes she would never edit)
Options: Stay at top of main.md as HTML (she sees code first, told "don't touch") / Move into a layout/include in everything_else/ (main.md 100% Markdown; photo swap = replace images/headshot.jpg).
Answer: **Stay at top of main.md as HTML**

**Q5. README.md: does it count as a 5th root item, or go into everything_else/?**
Options: Root, rewritten as her instructions (repo front page shows how-to) / Into everything_else/, root stays 4 items (front page shows only a file list).
Answer: **Into everything_else/, root stays 4 items**

**Q6. What happens to the unused template files (Dockerfile, docker-compose, .devcontainer, package.json, CONTRIBUTING)?**
Options: Delete them / Move them into everything_else/ untouched.
Answer: **Delete them**

**Q7. When do we flip Pages from 'deploy from branch' to 'GitHub Actions'?**
Options: After HTTPS is issued and enforced (restructure on a branch, merge + flip once cert live) / Now, don't wait (small unknown risk cert issuance restarts) / Now, but keep branch-build compatible as fallback (duplicate _config.yml at root temporarily).
Answer: **Now, don't wait**

**Q8. Who clicks Settings → Pages → Source = GitHub Actions at cutover, and are you admin on the repo?**
Options: Isabela clicks, I'm not admin / I'm admin, I click / Ask her to make me admin first.
Answer: **Isabela clicks, I'm not admin**

**Q9. How do Isabela's edits reach the live site?** (cross-check of "prevent" failure path)
Options: Direct commit to main from web editor / Web editor opens a pull request (branch protection; Jose reviews) / Direct commit + preview link (listed only to rule out; not possible on Pages).
Answer: **Direct commit to main from web editor**

**Q10. What's the acceptance bar for how the site looks after conversion?**
Options: Pixel-identical to today / Visually close, small drift OK / Keep .pub class via `{: .pub}` tag per paper.
Answer: **Visually close, small drift OK**

**Q11. Do you want a local preview path kept in the repo for yourself?**
Options: Yes: a script in everything_else/ (mirrors workflow staging; Ruby-4 shims baked in) / No: CI is the preview / Yes, but outside the repo.
Answer: **Yes: a script in everything_else/**

**Confirm. Does this summary match your understanding? Confirm to hand off to /compound-engineering:ce-plan.**
Answer: **Yes, proceed to ce-plan**

## Clarifications

- **Branch:** work directly on `main` (Jose's explicit choice, matches decisions.md 11b). No feature branch, no PR. Nothing goes live until Jose pushes from VS Code.
- **Division of labour:** Phase 0 is Isabela + Jose (outside this run). Phase 1 (pure `git mv`/`git rm` + tag) was executed and committed by Claude before Codex starts, so the plan file itself now lives at `everything_else/docs/plans/…`. Codex executes **Phases 2, 3 and 4 as file edits only** and ticks their checkboxes; Codex must not run `git commit`, `git tag`, `git push`, or change branches. Claude commits afterwards in three commits by file group (2: `.github/`, `everything_else/_config.yml`, `everything_else/preview.sh`, `.gitignore`; 3: `main.md`, `everything_else/assets/css/main.scss`; 4: `everything_else/README.md`, `everything_else/docs/planning/decisions.md`, this plan).
- **Paths after Phase 1:** `_config.yml`, `assets/css/main.scss`, `README.md`, `docs/` etc. referenced in Phases 2–4 are under `everything_else/`. `main.md` is at repo root and still contains its original front matter block (lines 1–6) — Phase 3 removes it (the staging step injects it).
- **Verification available to Codex:** `everything_else/preview.sh` cannot be exercised end-to-end inside the Codex sandbox if brew Ruby/bundle are unreachable; in that case Codex validates the staging logic by running only the staging commands into `$TMPDIR` and checking `index.md` starts with `---` and `permalink: /`, and validates the workflow YAML with `python3 -c "import yaml,sys; yaml.safe_load(open('.github/workflows/pages.yml'))"`. Claude runs the real preview build afterwards.
- **Content conversion rule (Phase 3.3):** the ten `<p class="pub">` blocks map to Markdown one-to-one; every URL and every visible word must survive verbatim (Claude checks by diffing sorted URL lists against `git show pre-restructure:_pages/main.md`). Two trailing spaces on every line inside a paper block except the last. The `## RESEARCH`, `### Working Papers`, `## Peer-reviewed publications`, `## Other publications` headings stay exactly as they are.

## Falsifiable core

### Decisions (each with the rejected alternative)

1. **Build via GitHub Actions workflow** (`.github/workflows/pages.yml`: stage → `actions/jekyll-build-pages@v1` → `actions/upload-pages-artifact` → `actions/deploy-pages`). Rejected: native branch build — GitHub Pages hard-overrides `source` to repo root, so internals cannot leave root. Rejected: two-repo split — more plumbing than a one-owner site warrants.
2. **Root = `main.md`, `files/`, `images/`, `everything_else/`, `.github/`, `.gitignore`.** Rejected: README at root — Jose chose a strictly 4-item root; instructions live in `everything_else/README.md` and in the HTML comment atop `main.md`.
3. **`main.md` carries no front matter; the staging step prepends it** when copying to `_stage/index.md`. Rejected: front matter in her file (one stray character = failed build). Rejected: `_config.yml` `defaults:` alone — Jekyll does not process a `.md` file with no front matter at all, so a default cannot rescue it; injection at staging is the only way to keep her file bare.
4. **Papers rewritten as Markdown** (bold link title, two-space line endings) and CSS retargeted from `p.pub` to generic selectors. Rejected: keep HTML blocks (unbalanced tag garbles page). Rejected: `{: .pub}` kramdown attribute per block (cryptic line she must copy). Rejected: YAML data file (second file to edit, YAML indentation trap). Rejected: pixel-identical bar (Jose accepted small drift).
5. **Header block (logo + headshot HTML) stays atop `main.md`,** followed by `<!-- ===== EDIT BELOW THIS LINE ===== -->`. The `<div style="text-align: justify;" markdown="1">` wrapper around the bio is removed and replaced by a CSS rule so nothing she edits sits inside an HTML tag. Rejected: move header into a layout include (Jose preferred it visible in her file).
6. **Delete** `Dockerfile`, `docker-compose.yaml`, `.devcontainer/`, `package.json`, `CONTRIBUTING.md`, `_pages/sitemap.md` (template cruft; `jekyll-sitemap` already emits `/sitemap.xml`). **Move** into `everything_else/`: `_config.yml`, `_layouts/`, `_includes/`, `_sass/`, `_data/`, `_pages/404.md`, `assets/`, `Gemfile`, `LICENSE`, `README.md`, `docs/`, and `CNAME`. Rejected: keep template leftovers. Rejected: delete `CNAME` — under Actions it is ignored, but in legacy branch mode GitHub treats CNAME removal as "remove custom domain"; keeping the file (staged into the build root) costs nothing and protects a rollback.
7. **Cutover now.** Sequence: Isabela flips Pages source to "GitHub Actions" **first** (site stays frozen on last deployment), **then** Jose pushes. Rejected: push first then flip — the native branch build would fire on the push, find no `_config.yml` at root, and deploy a junk site during the gap. Rejected: wait for HTTPS cert.
8. **Isabela commits straight to `main`** from the github.com editor. Rejected: PR flow (she waits on Jose; must learn PR dialog).
9. **`everything_else/preview.sh`** replicates the staging step and runs `jekyll serve` with the Ruby-4 shims, staging into a directory outside Dropbox. Rejected: CI-only preview; rejected: script outside repo (staging logic would live in two places).

### Assumptions (checkable)

- A1. `actions/jekyll-build-pages@v1` accepts `source: _stage` (a subdirectory) — verified in its `action.yml`/`entrypoint.sh` (`SOURCE_DIRECTORY=${GITHUB_WORKSPACE}/$INPUT_SOURCE`). It ignores the Gemfile except for a warning.
- A2. Under a custom workflow, a `CNAME` file is ignored and the custom domain persists in Settings (docs.github.com, "managing a custom domain"). Whether an in-flight certificate request survives the source switch is **unverified**; if the cert stalls > 24 h after cutover, remove and re-add the domain in Settings.
- A3. All asset/image/PDF hrefs resolve from site root via `base_path` (`_includes/base_path`), so relocating the *source* tree changes nothing in output as long as `assets/`, `images/`, `files/` land at the staging root.
- A4. kramdown GFM renders the Markdown paper block into `<p><strong><a>…</a></strong> …<br />…</p>` — verified locally with kramdown from the github-pages bundle; structure identical to today minus the `class="pub"`.
- A5. Local preview works with brew Ruby 4.0.6 + scratch Gemfile (csv, base64, bigdecimal, logger, ostruct) + `RUBYOPT` shim defining `Object#tainted?` — verified 2026-09-03 (`jekyll build` succeeded in 2.4 s).
- A6. Jekyll `include: [_pages, files]` and `exclude: [docs, Gemfile, LICENSE, README, .github]` in `_config.yml` remain correct relative to the staging root.

### Kill criteria

- If `jekyll-build-pages` cannot build the staged tree (theme/plugin path error), fall back to a plain `ruby/setup-ruby` + `bundle exec jekyll build` step using `everything_else/Gemfile`. If that also fails within one review round, abort: `git revert` the restructure commit and have Isabela flip Pages back to "Deploy from a branch".
- If the first Actions deploy does not serve `http://www.isabelamanelici.com/` with the bio text within 10 minutes of a green run, stop and diagnose before any content conversion is pushed.

## Implementation phases

### Phase 0 — Pre-flight (Jose + Isabela, no code)

- [ ] 0.1 Jose confirms on GitHub: `main` at `f07605a`, working tree clean, `git pull` up to date.
- [ ] 0.2 Isabela: Settings → Pages → Build and deployment → Source = **GitHub Actions**. Nothing else. Site stays live on the last branch deployment.
- [ ] 0.3 Jose verifies `curl -s https://api.github.com/repos/isabelamanelici/isabelamanelici.github.io/pages` (needs auth) or simply that Settings shows "GitHub Actions". Unauthenticated fallback: none; trust the screenshot.

### Phase 1 — Move files (pure `git mv`, one commit, no content edits)

- [ ] 1.0 `git tag pre-restructure f07605a` (rollback anchor; Jose pushes tags with `git push --tags`).
- [ ] 1.1 `mkdir everything_else` and `git mv` into it: `_config.yml _layouts _includes _sass _data _pages assets Gemfile LICENSE README.md docs CNAME`.
- [ ] 1.2 `git mv everything_else/_pages/main.md main.md` (content untouched in this commit); `git rm everything_else/_pages/sitemap.md`.
- [ ] 1.3 `git rm -r Dockerfile docker-compose.yaml .devcontainer package.json CONTRIBUTING.md`; `git rm --cached .DS_Store` (already in `.gitignore`).
- [ ] 1.4 `.gitignore`: add `_stage/`, `_site/`, `everything_else/_site/`, `.jekyll-cache/`.
- [ ] 1.5 Commit: `refactor: move Jekyll internals into everything_else/, main.md to root`. Verify `git show --stat` shows renames (similarity 100 %) and exactly 7 deletions (Dockerfile, docker-compose.yaml, .devcontainer/devcontainer.json, package.json, CONTRIBUTING.md, _pages/sitemap.md, .DS_Store).

### Phase 2 — Workflow + staging

- [ ] 2.1 Create `.github/workflows/pages.yml`:

```yaml
name: Build and deploy site
on:
  push:
    branches: [main]
  workflow_dispatch:
permissions:
  contents: read
  pages: write
  id-token: write
concurrency:
  group: pages
  cancel-in-progress: false
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Stage site source
        run: |
          set -euo pipefail
          rm -rf _stage
          mkdir _stage
          cp -R everything_else/. _stage/
          cp -R files images _stage/
          {
            printf -- '---\npermalink: /\ntitle: ""\nauthor_profile: false\n---\n'
            cat main.md
          } > _stage/index.md
      - name: Soft checks (warn only, never fail)
        run: |
          # odd number of ** => probably an unclosed bold
          n=$(grep -o '\*\*' main.md | wc -l); [ $((n % 2)) -eq 0 ] || echo "::warning file=main.md::Unbalanced ** in main.md (count=$n)"
          # links: every [ should have a matching ](
          a=$(grep -o '\[' main.md | wc -l); b=$(grep -o '](' main.md | wc -l); [ "$a" -eq "$b" ] || echo "::warning file=main.md::Possible broken link syntax in main.md ([=$a, ](=$b)"
          # PDF names: letters, digits, _ - . only
          for f in files/*; do case "$(basename "$f")" in *[!A-Za-z0-9_.-]*) echo "::warning::File name with spaces/special chars in files/: $f (links to it will break)";; esac; done
      - uses: actions/configure-pages@v5
      - uses: actions/jekyll-build-pages@v1
        with:
          source: ./_stage
          destination: ./_site
      - uses: actions/upload-pages-artifact@v3
        with:
          path: ./_site
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v5
```

- [ ] 2.2 In `everything_else/_config.yml`: `include:` keep `_pages`, `files`; in the single `exclude:` block (line 162) add `preview.sh` and `README.md` (`docs`, `Gemfile`, `LICENSE`, `README` prefix already there). Leave `url`, `baseurl`, `defaults` unchanged.
- [ ] 2.3 `everything_else/preview.sh` (executable): same staging commands as 2.1 but into `${TMPDIR:-/tmp}/manelici-stage`, then `bundle exec jekyll serve --source <stage> --destination <stage>/_site -l` with `PATH=/opt/homebrew/opt/ruby/bin:$PATH`, `BUNDLE_PATH=$HOME/.cache/bundle-manelici`, `BUNDLE_GEMFILE` pointing at a scratch Gemfile the script writes (eval_gemfile of `everything_else/Gemfile` + `csv base64 bigdecimal logger ostruct`), and `RUBYOPT=-r<shim> -W0` where the shim defines `Object#tainted?/taint/untaint`. Stage dir outside Dropbox by construction.
- [ ] 2.4 Commit: `ci: build site from everything_else/ + root content via GitHub Actions`. Jose pushes both commits (Phase 1 + 2) together from VS Code.
- [ ] 2.5 Watch Actions tab. Green → check `http://www.isabelamanelici.com/` shows bio; PDFs at `/files/CV_Manelici.pdf`; `/404.html` renders; `/sitemap.xml` exists. Red → kill criterion 1.

### Phase 3 — Content conversion (`main.md`)

- [ ] 3.1 Top of file unchanged (logo/headshot `<div style="float:left…">`). Immediately after it insert:

```html
<!-- ============================================================
     EDIT BELOW THIS LINE. Everything above is the photo/logo block.
     Bio: plain text; links look like [text](https://url).
     Papers: copy one whole paper block (from the bold title line to
     the blank line) and edit it. Keep the two spaces at line ends.
     ============================================================ -->
```

- [ ] 3.2 Remove `<div style="text-align: justify;" markdown="1">` and its `</div>`; add to `everything_else/assets/css/main.scss`: `.page__content p { text-align: justify; }` (paper lines end in hard breaks so justification does not stretch them).
- [ ] 3.3 Convert each of the 10 `<p class="pub">…</p>` blocks to Markdown, e.g.:

```markdown
**[Responsible Sourcing? Evidence from Costa Rica](/files/Responsible_Sourcing_CR.pdf)** [(link)](/files/Responsible_Sourcing_CR.pdf). [NBER WP 30683](https://www.nber.org/papers/w30683)  
with [Alonso Alfaro-Ureña](https://sites.google.com/view/alfarourena/home), [Benjamin Faber](https://eml.berkeley.edu/~faberb/), [Cecile Gaubert](https://eml.berkeley.edu/~cecile.gaubert/), and [José P. Vasquez](https://jpvasquez-econ.github.io/)  
Status: *Second round Revise-and-Resubmit* at the **American Economic Review**  
[Trade Talks podcast episode (39 mins)](https://tradetalkspodcast.com/podcast/188-did-responsible-sourcing-by-multinationals-help-workers-in-poor-countries/), [VoxDev summary](https://voxdev.org/topic/firms/responsible-sourcing-theory-and-evidence-costa-rica), [VoxEU summary](https://cepr.org/voxeu/columns/responsible-sourcing-theory-and-evidence-costa-rica)
```

  Every URL and every word of text is carried over verbatim; only markup changes. Journal names in `<em>` become `*…*`.
- [ ] 3.4 CSS in `everything_else/assets/css/main.scss`: replace the four `p.pub` rules with equivalents on `.page__content p > strong:first-child`, `.page__content p > strong:first-child a` (color `#6b0000`, no underline, underline on hover), and give `.page__content p` the `1.1em` bottom margin the `.pub` rule had (bio paragraphs get slightly more air: accepted drift).
- [ ] 3.5 `preview.sh`, open localhost, compare side by side with `http://www.isabelamanelici.com/` (pre-conversion). Accept if headings, red bold titles, line breaks, link colours match; small spacing drift OK.
- [ ] 3.6 Commit `content: paper entries as Markdown; edit-below-this-line guard`. Push. Verify live.

### Phase 4 — Instructions for Isabela

- [ ] 4.1 Rewrite `everything_else/README.md` (≤ 40 lines): how to edit `main.md` in the browser, how to upload a PDF into `files/` and link it as `/files/Name.pdf` (no spaces in filenames), how to swap `images/headshot.jpg` (same filename), where to see build status (Actions tab), "if something breaks, email Jose; nothing is lost, every version is in History".
- [ ] 4.2 Update `everything_else/docs/planning/decisions.md` "Open items": split item 5 into (a) CNAME/DNS migration — done 2026-09-03, and (b) Wix shutdown — moot, Wix plan expired; add "renew domain at Network Solutions/Wix before 2026-10-09"; add item "Pages now built by GitHub Actions from everything_else/, see this plan".
- [ ] 4.3 Commit `docs: owner instructions and decisions update`. Push.

## Acceptance criteria

- [ ] `git ls-files | cut -d/ -f1 | sort -u` prints exactly: `.github .gitignore everything_else files images main.md`.
- [ ] `main.md` first line is `<div` (no `---`); `grep -c '^---' main.md` = 0.
- [ ] Workflow green on `main`; `http://www.isabelamanelici.com/` returns 200 with "Welcome to my website"; all 9 `/files/*.pdf` return 200; `/404.html` returns the template 404.
- [ ] `grep -c 'class="pub"' main.md` = 0; every URL present in `f07605a:_pages/main.md` is present in new `main.md` (diff of sorted `grep -o 'https\?://[^)" ]*'` is empty).
- [ ] `everything_else/preview.sh` serves the site locally on the Ruby-4 machine without touching the repo tree.
- [ ] Rollback verified on paper: `git revert` of the four commits (Phases 4→1, reverse order) or `git reset --hard pre-restructure` + force-push, then Isabela flips Source back to "Deploy from a branch", restores the pre-plan site.

## Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Jose pushes before Isabela flips Source | Medium | Phase 0.2 is a hard gate; Jose asks for screenshot first |
| Cert provisioning restarts on source switch | Unknown | Wait 24 h; then remove/re-add domain in Settings |
| `jekyll-build-pages` rejects staged tree | Low (verified `source` input) | Kill criterion 1 fallback to `setup-ruby` build |
| Isabela breaks Markdown (unbalanced `**`) | Medium, recurring | Never fails build; page looks odd; Jose reverts via History. README explains |
| PDF uploaded with spaces in name | Medium | README rule; link still works if URL-encoded but ugly |
| Two pushes in quick succession | Low | `concurrency: pages`, `cancel-in-progress: false` queues them |
| Dropbox syncs `_stage/`/`_site/` | Low | preview.sh stages under `$TMPDIR`; `.gitignore` covers in-repo dirs |
| Isabela edits/deletes the header `<div>` above the guard comment | Low | Comment says don't; nothing fails; Jose restores from History (README step). Jose rejected moving it into a layout |
| Broken Markdown never surfaces as an error | Medium | Soft-check step annotates the Actions run with a warning (never fails, per decision 2/8); README tells her to glance at the green/yellow tick |

## SpecFlow findings not adopted

- Fail the build on Markdown lint errors → contradicts decision 2 (prevention, not failure); warnings only.
- Move the header block into an include → contradicts decision 5 (Jose chose to keep it in `main.md`).
- `cancel-in-progress: true` → not needed for a one-editor site; queued deploys are safer.
- Wait for the certificate before cutover → contradicts decision 7.

## Sources

- Grilling transcript (Section 2), this session.
- Repo audit (this session): `_includes/base_path`, `_config.yml:158-190` include/exclude, `:235-288` defaults, `:292-294` sass_dir; `assets/css/main.scss:96-114` `.pub` rules; `_pages/main.md:1-6` front matter.
- `actions/jekyll-build-pages` `action.yml`, `entrypoint.sh` (v1.0.13; ruby:3.3-slim; github-pages 232) — https://github.com/actions/jekyll-build-pages
- Starter workflow — https://github.com/actions/starter-workflows/blob/main/pages/jekyll-gh-pages.yml
- Custom domains under workflows (CNAME file ignored) — https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site
- Native build overridden keys (`source`) — https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll
- Prior plan: `docs/plans/2026-04-17-001-feat-port-manelici-wix-to-academicpages-plan.md`; decisions: `docs/planning/decisions.md`.

## Codex critique (2026-09-03)

Triage: three ambiguities fixed in place (deletion count → 7; rollback → four commits or `pre-restructure` tag; decisions.md item split). Stale ref fixed (there is one `exclude:` block, not two). The gap is Phase 0.2 — the Pages-source flip cannot be verified from the repo; Jose gates on Isabela's screenshot.

### AMBIGUITIES

- “Verify `git show --stat` shows … only the 6 deletions” conflicts with the explicit removal of seven tracked files: the five template targets, `_pages/sitemap.md`, and `.DS_Store`. I would follow the explicit commands and expect seven deletions.

- “Rollback verified on paper: `git revert` of the three commits” conflicts with the four commits specified in Phases 1–4. I would treat rollback as reverting all four commits in reverse order.

- “Update … `decisions.md` ‘Open items’: mark deploy done” has no corresponding deployment item. The closest item combines CNAME/DNS migration with the still-separate Wix shutdown decision. I would split that item, mark deployment/domain migration complete, and leave Wix shutdown open.

### GAPS

- Has Isabela already changed Settings → Pages → Source to **GitHub Actions**, and is there confirmation? The plan defines this as a hard gate before any restructure is pushed; the repository cannot reveal that setting.

### STALE REFS

- The plan says `_config.yml` contains a duplicated `exclude:` block around lines 162–190. The file contains exactly one `exclude:` block, beginning at line 162, so there is no duplicate to remove.