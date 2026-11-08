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
  version "0.1.5"

  on_macos do
    on_arm do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.5/cru-darwin-arm64"
      sha256 "5fdf1bba264b6037792364b50851a40c35ab42f552b385236cf69550f1b00bb6"
    end
    on_intel do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.5/cru-darwin-x64"
      sha256 "480bd2592ff1a30377d8240841e3e1614f47115a12b0cc5ee033f89f2e82afc6"
    end
  end

  on_linux do
    on_arm do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.5/cru-linux-arm64"
      sha256 "291658c92e9c5048609211086f11f5bfac80c620d4deb6677324f3104cc9767c"
    end
    on_intel do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.5/cru-linux-x64"
      sha256 "879c524544e964a75a1709e3505f1d90e07b29b2d1124ede889de3f669c38ba7"
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
