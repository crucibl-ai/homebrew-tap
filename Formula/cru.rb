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
  version "0.1.4"

  on_macos do
    on_arm do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.4/cru-darwin-arm64"
      sha256 "0ecc314ca731f214fc1964222e0851d2494dfb24a0771d7cf8f0273780d36eae"
    end
    on_intel do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.4/cru-darwin-x64"
      sha256 "17701b2095eda7f245f7b97951003104ef41516589d9a86972b43329d0d16e09"
    end
  end

  on_linux do
    on_arm do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.4/cru-linux-arm64"
      sha256 "5d72c94a154d5846a0edf2949692b3357e0d701d7cf487176ebcec5561477a01"
    end
    on_intel do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.4/cru-linux-x64"
      sha256 "8ac18a5736e23d58c5453fdd6f85ea0b4f5eb584f47f9688fe7624f229d73df0"
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
