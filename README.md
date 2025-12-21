# samcaldwell.net

A simple Jekyll site for samcaldwell.net. Local development is containerized with Docker and driven via Make.

## Quick Start

- Requirements: Docker, Make
- Dev server: `make dev` then open `http://localhost:4000`
- Stop container: `make stop`
- Network binding: dev ports bind to `127.0.0.1` by default via `-p 127.0.0.1:HOST:CONTAINER` so the site is only reachable locally. To override (e.g., for LAN testing), run `BIND_ADDRESS=0.0.0.0 make dev`.

## Gists

- Enabled via `jekyll-gist` (configured in Gemfile and `_config.yml`).
- Usage in posts/pages:
  - By ID only: `{% gist 1234567890abcdef %}`
  - Specific file in a gist: `{% gist 1234567890abcdef file.rb %}`
  - Works in Markdown and HTML posts.

## Jokes

- Add jokes as pages under `jokes/` (e.g., `jokes/my-joke.html`).
- One-liner: `make joke TITLE="My Joke"`
- Interactive: `make joke` and enter a title when prompted
- Each file must include front matter so Jekyll processes it, for example:

  ---
  title: My Joke
  description: Optional short summary
  ---

- The list is available at `/jokes/` and is linked in the nav.

## Create a New Blog Post

- One-liner: `make post TITLE="My First Post"`
- Interactive: `make post` and enter a title when prompted
- What it does:
  - Creates `_posts/YYYY-MM-DD-my-first-post.md`
  - Adds front matter (`layout: page`, `title`, `date`, `description`, `tags`)
  - The post auto-appears on `/blog/`

### Import from DOCX (preserves math)

- Requires: `pandoc` (install via Homebrew: `brew install pandoc`)
- Command: `make import-docx DOCX=CRSCE-2025-v1.docx TITLE="Cross Sums Compression and Expansion (CRSCE)"`
- Output: `_posts/YYYY-MM-DD-cross-sums-compression-and-expansion-crsce.html` with `math: true` and HTML/MathML for equations.

## Project Structure

- `_layouts/` — `default.html` (site chrome), `page.html` (wraps page/post content)
- `_includes/` — shared partials (`head`, `header`, `nav`, `footer`)
- `pages/` — top-level pages (e.g., `/about/`, `/gpg-keys/`, `/blog/`)
- `_posts/` — blog posts named `YYYY-MM-DD-title.md`
- `_data/navigation.yml` — nav items rendered by `_includes/nav.html`
- `css/`, `js/`, `img/` — static assets
- `jokes/` — individual joke pages (listed at `/jokes/`)
- `.well-known/` — included for deployment via `_config.yml`

## Configuration

- `_config.yml`
  - `permalink: pretty`
  - Posts default to `layout: page` to use the global template
  - Plugins: `jekyll-seo-tag`, `jekyll-sitemap`
  - `exclude:` includes `README.md` so it’s not published
  - MathJax loads when `page.math: true` or `site.math: true`.

## Notes

- Bootstrap sourcemap requests are disabled to avoid 404s in dev.
- A devtools probe placeholder lives at `.well-known/appspecific/com.chrome.devtools.json`.

## License

Not specified in this repository. If you need one, add it explicitly.
