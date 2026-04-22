# CLAUDE.md

## Project Overview

Jekyll 4.3 static site for [samcaldwell.net](https://samcaldwell.net) — a personal portfolio/blog.
Deployed to GitHub Pages. Local dev is containerized with Docker and driven via Make.

## Tech Stack

- **Generator**: Jekyll 4.4 (Ruby)
- **CSS**: Bootstrap 5 (prebuilt/minified) + custom `css/index.css`
- **JS**: Bootstrap bundle, MathJax (git submodule in `js/MathJax/`)
- **Plugins**: `jekyll-seo-tag`, `jekyll-sitemap`, `jekyll-gist`
- **Dev environment**: Docker (Ubuntu 24.04), Make
- **CI**: GitHub Actions (CodeQL, Dependabot auto-merge)

## Common Commands

```sh
make dev                        # Build Docker image + start Jekyll dev server (localhost:4000)
make stop                       # Stop the dev container
make build                      # Build Docker image only
make post TITLE="My Post"       # Scaffold a new blog post in _posts/
make book TITLE="Book Title"    # Scaffold a new book page in books/
make joke TITLE="A Joke"        # Scaffold a new joke page in jokes/
make epitaph TITLE="Title"      # Scaffold a new epitaph page in epitaphs/
```

LAN access: `BIND_ADDRESS=0.0.0.0 make dev`

```sh
npm ci                          # Install Playwright and dependencies
npx playwright test --config e2e/playwright.config.ts  # Run e2e tests against production
```

## Project Structure

```
_layouts/        Jekyll layout templates (default.html, page.html)
_includes/       Reusable partials (head, header, nav, footer)
_data/           Data files (navigation.yml drives the nav bar)
_posts/          Blog posts (YYYY-MM-DD-slug.md|html)
pages/           Top-level pages (about, blog, books, gpg-key, etc.)
books/           Book review/notes pages
jokes/           Individual joke pages
epitaphs/        Epitaph pages
dashboards/      Dashboard pages
css/             Stylesheets (Bootstrap minified + custom index.css)
js/              JavaScript (Bootstrap bundle, MathJax submodule)
img/             Images and favicons
docker/          Docker entrypoint script
.well-known/     MTA-STS, DevTools probe
.github/         CI workflows and Dependabot config
```

## Content Conventions

- **Front matter** is required on all content files:
  ```yaml
  ---
  layout: page
  title: Title Here
  date: YYYY-MM-DD HH:MM:SS+ZZZZ
  description: Short summary
  keywords: keyword1, keyword2
  math: true          # optional — enables MathJax on this page
  ---
  ```
- Posts use `_posts/YYYY-MM-DD-slug.md` naming (lowercase, hyphen-separated slug).
- All content types default to `layout: page` via `_config.yml` defaults.
- Navigation is defined in `_data/navigation.yml`.

## Styling

- Dark theme: `#333333` background, `#ffffff` text.
- Responsive via Bootstrap grid. System font stack (no custom fonts).
- Code blocks use dark syntax highlighting (GitHub-style palette).
- Custom utility classes: `.indented`, `.center`, `.left`, `.right`.

## Deployment

- GitHub Pages via the `CNAME` file (`samcaldwell.net`).
- Static output only — no server-side runtime.
- CodeQL scans JavaScript and Ruby on push/PR/weekly schedule.
- Dependabot auto-merges patch and minor dependency updates (squash merge).

## Key Files

- `_config.yml` — Jekyll config (permalink, plugins, layout defaults, excludes)
- `Gemfile` / `Gemfile.lock` — Ruby dependencies
- `Makefile` — All dev/build/scaffolding commands
- `Dockerfile` — Dev container (Ubuntu 24.04 + Ruby + Jekyll)
- `docker/dev-entrypoint.sh` — Container entrypoint (bundle install + jekyll serve)
