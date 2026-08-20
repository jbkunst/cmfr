# cmfr development conventions

## Core package

- Keep the package small, maintainable, and dependency-light.
- Use `snake_case` for the public R API and normalized output columns.
- Prefer functions with one responsibility.
- Design the main interface around `metadata()`, `resolve_*()`,
  `describe_*()`, and `get_*()` when those concepts match the CMF
  source.
- Only `resolve_*()` interprets human-language text. `describe_*()` and
  `get_*()` require exact identifiers.
- Return simple `tibble`s with predictable columns. Do not add S3
  classes, R6 clients, caches, local databases, or unnecessary
  abstractions.
- The package must not know about LLMs, `ellmer`, MCP, or tool-calling.
  Tool wrappers belong outside the package.
- Keep low-level access separate from the main interface. If exported,
  place it last in pkgdown Reference under **API de bajo nivel /
  legacy**.
- If an operation performs multiple requests, inform the user with
  [`rlang::inform()`](https://rlang.r-lib.org/reference/abort.html) and
  support `verbose` plus `options(cmfr.verbose = FALSE)`.
- Credentials must come from environment variables or CI secrets. Never
  commit credentials or embed them in code/examples.

## Documentation

- Keep `README.md` short and repository-centered.
- Use `pkgdown/index.md` as the more explanatory pkgdown home page.
- Put executable examples and plots in `vignettes/`, not in the README.
- `NEWS.md` is the single source of truth for the changelog.
- Configure pkgdown in Spanish with `lang: es` and build it under a
  Spanish locale in GitHub Actions.

## Scope

- Prefer official CMF APIs or official download mechanisms over
  scraping.
- Do not add plotting wrappers, modeling, forecasting, or cross-source
  joins to the core package unless explicitly justified later.
