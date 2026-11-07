# Homebrew formula for cru, rendered by packaging/homebrew/render.sh from a
# release's SHA256SUMS and pushed to crucibl-ai/homebrew-tap as Formula/cru.rb
# by .github/workflows/release.yml. Do not edit the copy in the tap by hand;
# change this template and cut a release (docs/release.md).
#
# The assets are the bun-compiled static binaries release.yml publishes to the
# internal release mirror under cru/core/<version>/ (DESIGN §3.4, §7.2), the
# same files `cru self-update` reads. Each is a bare executable, not an
# archive, so Homebrew stages it under its asset name and `install` renames it.
#
# The mirror's certificate chains to the Crucibl internal root CA, which the
# MDM pushes to every managed Mac. Homebrew downloads with the system curl
# (/usr/bin/curl, Secure Transport), which trusts the system keychain, so the
# root is honoured and no extra setup is needed. HOMEBREW_FORCE_BREWED_CURL
# would switch to a curl with its own CA bundle and fail verification; on
# Linux, or on an unmanaged machine, install the root into the CA bundle first
# (docs/mirror.md). The mirror is reachable from the office network and the
# tailnet only.
class Cru < Formula
  desc "One command-line client for Crucibl: login, and every product's commands as self-updating plugins"
  homepage "https://github.com/crucibl-ai/cru"
  version "0.1.1"

  on_macos do
    on_arm do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.1/cru-darwin-arm64"
      sha256 "7b5970806198e6e79693d1e3ec96e42574f80fe9a0682e20dfa20f7cae6a91a2"
    end
    on_intel do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.1/cru-darwin-x64"
      sha256 "6fe2800acb494008b5957146097e0a3b936364866cab396ded5641a948718860"
    end
  end

  on_linux do
    on_arm do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.1/cru-linux-arm64"
      sha256 "417a036c13398c9ced1f4a9d858a29206d4ecafd84a24e08b5c86de5628d7cb3"
    end
    on_intel do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.1/cru-linux-x64"
      sha256 "498c8b7813d8f50d5734bc75dfccc158e285265c36887a07d429b2a405c27c2d"
    end
  end

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    bin.install "cru-#{os}-#{arch}" => "cru"
  end

  def caveats
    <<~EOS
      Log in once with
        cru login
      Every product's commands are plugins the core installs on first use:
        cru help
    EOS
  end

  test do
    assert_match "cru", shell_output("#{bin}/cru --help")
  end
end
