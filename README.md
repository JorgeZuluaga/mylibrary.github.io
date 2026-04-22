# mylibrary.github.io template

Static personal-library template for GitHub Pages.

## What this includes
- `index.html` as the main library dashboard.
- `all-books.html` for the complete list.
- `info/library.json` as source of truth.
- Sample reviews in `reviews/`.
- Scripts in `bin/` to import Goodreads data and mirror reviews.
- `update/` for downloaded source files (RSS, HTML, bib exports, etc.).

## Quick start
```bash
make start
```
Open `http://127.0.0.1:8000`.

Stop server:
```bash
make stop
```

## Update library from Goodreads
### 1) Get your Goodreads RSS URL

Use the Goodreads RSS endpoint for your review list. The format is:

```text
https://www.goodreads.com/review/list_rss/YOUR_USER_ID?key=YOUR_KEY&shelf=%23ALL%23
```

How to get it:
- Open Goodreads and go to your profile/books list.
- Look for RSS in your review list page.
- Copy the full URL including `user_id` and `key`.

### 2) (Optional but recommended) Get your Goodreads COOKIE for likes scraping

Without cookie, Goodreads can return login pages for some reviews and likes can be `0`.

Steps:
1. Sign in to Goodreads in your browser.
2. Open one of your review pages (`https://www.goodreads.com/review/show/...`).
3. Open DevTools (`F12`) and go to Network.
4. Refresh page.
5. Click the main document request for that review page.
6. In Request Headers, copy the full `cookie` header value.
7. Export it in your shell:

```bash
export GR_COOKIE='session-id=...; at-main=...; ccsid=...; locale=en; ...'
```

Treat this as a password. Do not commit it.

### 3) Build `info/library.json`

```bash
make library-build \
  RSS_URL="https://www.goodreads.com/review/list_rss/YOUR_USER_ID?key=YOUR_KEY&shelf=%23ALL%23" \
  RSS_PAGES=20 \
  COOKIE="$GR_COOKIE"
```

Notes:
- Increase `RSS_PAGES` if old books are missing.
- If you do not want likes scraping, leave `COOKIE` empty.

### 4) Generate aggregated stats

```bash
make library-stats
```

This updates `info/library-stats.json`.

### 5) Mirror reviews to local HTML pages

Mirror one review first (smoke test):

```bash
make reviews-first COOKIE="$GR_COOKIE" REVIEW_RSS_PAGES=40
```

Mirror all reviews:

```bash
make reviews-all COOKIE="$GR_COOKIE" REVIEW_RSS_PAGES=40
```

Force regeneration of all mirrored reviews:

```bash
make reviews-force COOKIE="$GR_COOKIE" REVIEW_RSS_PAGES=40
```

### 6) Typical full refresh workflow

```bash
make library-build RSS_URL="https://www.goodreads.com/review/list_rss/YOUR_USER_ID?key=YOUR_KEY&shelf=%23ALL%23" RSS_PAGES=40 COOKIE="$GR_COOKIE"
make library-stats
make reviews-all COOKIE="$GR_COOKIE" REVIEW_RSS_PAGES=40
```

Then run locally and verify:
- `index.html`
- `all-books.html`
- sample review pages in `reviews/`

## Make targets

- `make start`: start local server in background.
- `make stop`: stop local server on selected port.
- `make dev`: run dev server (`bin/dev_server.py`).
- `make library-build`: build `info/library.json` from Goodreads RSS.
- `make library-stats`: build `info/library-stats.json`.
- `make library-refresh`: run `library-build` + `library-stats`.
- `make reviews-first`: mirror first review only.
- `make reviews-all`: mirror all reviews.
- `make reviews-force`: regenerate all mirrored reviews.

## `update/` directory

Use `update/` as a staging folder for downloaded source files (RSS exports, HTML snapshots, notes, etc.).  
The website does not read `update/` directly; runtime data comes from `info/*.json`.

## Publish
Push this repo to GitHub and enable Pages with `main` + `/(root)`.
