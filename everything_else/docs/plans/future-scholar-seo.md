---
title: Future work — Google Scholar indexing + SEO polish
type: feat
status: deferred
date: 2026-04-17
depends-on: docs/plans/2026-04-17-001-feat-port-manelici-wix-to-academicpages-plan.md
---

# Future — Google Scholar + SEO polish

Deferred from the MVP port plan. Only execute if Isabela asks "why don't my papers show up on Scholar?" or wants better social-media previews.

## Background

The MVP launches with `jekyll-seo-tag` handling Open Graph, Twitter cards, and canonical URLs. Scholar requires Highwire Press `citation_*` meta tags (e.g., `citation_title`, `citation_author`, `citation_pdf_url`) which `jekyll-seo-tag` does NOT emit. For these to render per-paper, each paper needs its own URL.

## Work items

1. **Promote publications from hardcoded inline in `_pages/main.md` to `_publications/*.md` files** with structured front matter:
   ```yaml
   ---
   title: "The Effects of Joining Multinational Supply Chains"
   authors: ["Alfaro-Ureña, Alonso", "Manelici, Isabela", "Vasquez, José P."]
   date: 2022-08-01
   journal: "Quarterly Journal of Economics"
   volume: 137
   issue: 3
   firstpage: 1495
   lastpage: 1552
   pdf: /files/Effects_of_Joining_MNC_Supply_Chains_QJE.pdf
   permalink: /publications/joining-mnc-supply-chains/
   ---
   ```
2. **Rewrite `_pages/main.md` to Liquid-loop over `site.publications` grouped by category** (working paper / peer-reviewed / other).
3. **Add `citation_*` meta tags to `_includes/head/custom.html`**:
   ```liquid
   {% if page.collection == "publications" %}
     <meta name="citation_title" content="{{ page.title | escape }}">
     {% for a in page.authors %}
       <meta name="citation_author" content="{{ a | escape }}">
     {% endfor %}
     <meta name="citation_publication_date" content="{{ page.date | date: '%Y/%m/%d' }}">
     {% if page.journal %}
       <meta name="citation_journal_title" content="{{ page.journal | escape }}">
       {% if page.volume %}<meta name="citation_volume" content="{{ page.volume }}">{% endif %}
       {% if page.issue %}<meta name="citation_issue" content="{{ page.issue }}">{% endif %}
       {% if page.firstpage %}<meta name="citation_firstpage" content="{{ page.firstpage }}">{% endif %}
       {% if page.lastpage %}<meta name="citation_lastpage" content="{{ page.lastpage }}">{% endif %}
     {% endif %}
     {% if page.pdf %}
       <meta name="citation_pdf_url" content="{{ page.pdf | absolute_url }}">
     {% endif %}
   {% endif %}
   ```
4. **Create `robots.txt`** at repo root allowing AI crawlers:
   ```
   User-agent: *
   Allow: /
   Sitemap: https://isabelamanelici.github.io/sitemap.xml
   ```
5. **Create 1200×630 Open Graph preview image** at `images/og-default.png` and add `logo: /images/og-default.png` to `_config.yml`.

## Sources

- [Google Scholar inclusion guidelines](https://scholar.google.com/intl/en/scholar/inclusion.html)
- [`jekyll-seo-tag` advanced usage](http://jekyll.github.io/jekyll-seo-tag/advanced-usage/)
