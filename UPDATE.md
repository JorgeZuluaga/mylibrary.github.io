# Update guide

## Typical workflow
1. Put raw downloads in `update/`.
2. Run `make library-build` to refresh `info/library.json`.
3. Run `make library-stats`.
4. Run `make reviews-all` to mirror review pages.
5. Verify `index.html` and `all-books.html` locally.
6. Commit and push.
