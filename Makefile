.PHONY: help start dev stop library-build library-stats library-refresh reviews-first reviews-all reviews-force

PORT ?= 8000
HOST ?= 127.0.0.1
LIBRARY_JSON ?= info/library.json
LIBRARY_STATS_JSON ?= info/library-stats.json
RSS_URL ?=
COOKIE ?=
RSS_PAGES ?= 1
REVIEW_RSS_PAGES ?= 40

help:
	@echo "make start|stop|dev|library-build|library-stats|reviews-all"

start:
	@echo "Starting server on http://$(HOST):$(PORT)"
	@nohup python3 -m http.server "$(PORT)" --bind "$(HOST)" >/dev/null 2>&1 &
	@sleep 0.2
	@echo "Started. Stop with: make stop"

dev:
	@python3 bin/dev_server.py --host "$(HOST)" --port "$(PORT)" --root "."

stop:
	@echo "Stopping server on port $(PORT) (best-effort)"
	@PID="$$(lsof -tiTCP:$(PORT) -sTCP:LISTEN 2>/dev/null | head -n 1)"; 	if [ -n "$$PID" ]; then 		echo "Killing pid $$PID"; 		kill "$$PID" 2>/dev/null || true; 		sleep 0.2; 		if kill -0 "$$PID" 2>/dev/null; then 			echo "Still running, forcing stop (SIGKILL)"; 			kill -9 "$$PID" 2>/dev/null || true; 		fi; 	else 		echo "No process listening on $(PORT)."; 	fi

library-build:
	@if [ -z "$(RSS_URL)" ]; then 		echo "RSS_URL is required."; 		exit 1; 	fi
	@python3 bin/build_library_from_goodreads.py --rss-url "$(RSS_URL)" --out "$(LIBRARY_JSON)" --rss-pages "$(RSS_PAGES)" --scrape-likes --cookie "$(COOKIE)" --verbose

library-stats:
	@python3 bin/update_library_stats.py "$(LIBRARY_JSON)" --out "$(LIBRARY_STATS_JSON)"

library-refresh: library-build library-stats
	@echo "Library refresh completed."

reviews-first:
	@python3 bin/mirror_first_review.py --library-json "$(LIBRARY_JSON)" --reviews-dir reviews --cookie "$(COOKIE)" --rss-pages "$(REVIEW_RSS_PAGES)"

reviews-all:
	@python3 bin/mirror_all_reviews.py --library-json "$(LIBRARY_JSON)" --reviews-dir reviews --cookie "$(COOKIE)" --rss-pages "$(REVIEW_RSS_PAGES)"

reviews-force:
	@python3 bin/mirror_all_reviews.py --library-json "$(LIBRARY_JSON)" --reviews-dir reviews --cookie "$(COOKIE)" --rss-pages "$(REVIEW_RSS_PAGES)" --force
