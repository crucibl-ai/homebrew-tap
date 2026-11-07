# crucibl-ai/homebrew-tap

Homebrew formulae for Crucibl's internal tools. Today that is `cru`, the Crucibl command line
([crucibl-ai/cru](https://github.com/crucibl-ai/cru)).

## Install cru

On a managed Mac, from the office network or the tailnet:

```sh
brew tap crucibl-ai/tap          # clones github.com/crucibl-ai/homebrew-tap with your git credentials
brew trust crucibl-ai/tap        # once per machine: Homebrew refuses formulae from a third-party tap until trusted
brew install cru
cru version                      # cru 0.1.1 (darwin-arm64)
cru login
```

`brew tap <owner>/<name>` is a naming convention: it clones `github.com/<owner>/homebrew-<name>`, which is why this
repo is called `homebrew-tap`. The repo is private, so the clone uses the git credentials on the machine (gh's
credential helper or the keychain). With SSH only: `brew tap crucibl-ai/tap git@github.com:crucibl-ai/homebrew-tap.git`.

The formula downloads the binary from the internal release mirror, `https://mirror.corp.crucibl.internal`, whose
certificate chains to the Crucibl internal root CA (in the keychain of every managed Mac). The mirror is only
reachable from the office network and the tailnet.

## Update cru

```sh
brew update && brew upgrade cru
```

`brew update` refreshes this tap's clone; without it `brew upgrade` can say cru is up to date while a newer
formula is here. `cru self-update` is the alternative that does not go through Homebrew.

## If it fails

| Message | Cause | Fix |
|---|---|---|
| `Refusing to load formula crucibl-ai/tap/cru from untrusted tap` | New Homebrew guard for third-party taps | `brew trust crucibl-ai/tap` |
| `Your Command Line Tools (CLT) does not support macOS N` | The formula has no bottle, so Homebrew treats it as a source build and checks the CLT, even though the install only renames a downloaded binary | Software Update, or `sudo rm -rf /Library/Developer/CommandLineTools && sudo xcode-select --install` |
| Download fails, `Could not resolve host: mirror.corp.crucibl.internal` | Not on the office network or the tailnet, or no DNS for the mirror | Join the tailnet; on a laptop away from the office, Tailscale split DNS for `corp.crucibl.internal` |
| `SSL certificate problem` on the download | The Crucibl internal root is not in the keychain (unmanaged machine), or `HOMEBREW_FORCE_BREWED_CURL` is set | Install the root (cru's `docs/mirror.md`); unset the variable |
| `cru version` is `unknown command` | 0.1.0 is installed; `version` arrived in 0.1.1 | `brew update && brew upgrade cru` |

## How the formula gets here

`Formula/cru.rb` is written by cru's release workflow on every `v*` tag: it renders `packaging/homebrew/cru.rb.tmpl`
with that release's `SHA256SUMS` and commits here as `github-actions[bot]` with the `HOMEBREW_TAP_TOKEN` secret.
Do not edit the formula by hand; cut a release instead (`docs/release.md` in cru).

Linux is supported (the formula has `on_linux` blocks); on a Pi or an SSH box, downloading the binary from the mirror
and checking it against `SHA256SUMS` is lighter than installing Homebrew.
