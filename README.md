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
1. Get your Goodreads RSS URL from your profile review list.
2. (Optional) export your authenticated cookie for scraping likes:
   ```bash
   export GR_COOKIE='session-id=...; at-main=...'
   ```
3. Build `info/library.json`:
   ```bash
   make library-build RSS_URL="https://www.goodreads.com/review/list_rss/YOUR_USER_ID?key=YOUR_KEY&shelf=%23ALL%23" RSS_PAGES=20 COOKIE="$GR_COOKIE"
   ```
4. Generate stats:
   ```bash
   make library-stats
   ```
5. Mirror local review pages:
   ```bash
   make reviews-all COOKIE="$GR_COOKIE" REVIEW_RSS_PAGES=40
   ```

## Publish
Push this repo to GitHub and enable Pages with `main` + `/(root)`.
