# crucibl-ai/homebrew-tap

Homebrew formulae for Crucibl's internal tools.

```sh
brew tap crucibl-ai/tap
brew install cruaccess
```

`Formula/cruaccess.rb` is written by the [ident](https://github.com/crucibl-ai/ident) release workflow on every
`v*` tag: it renders `packaging/homebrew/cruaccess.rb.tmpl` with that release's `SHA256SUMS` and commits here as
`github-actions[bot]`. Do not edit the formula by hand; cut a release instead (`docs/publishing.md` in ident).

Linux is supported (the formula has `on_linux` blocks); on a Pi or an SSH box, downloading the release binary
directly and checking it against `SHA256SUMS` is lighter than installing Homebrew.
