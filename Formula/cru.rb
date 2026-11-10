# Homebrew formula for cru, rendered by packaging/homebrew/render.sh from a
# release's SHA256SUMS and pushed to crucibl-ai/homebrew-tap as Formula/cru.rb
# by .github/workflows/release.yml. Do not edit the copy in the tap by hand;
# change this template and cut a release (docs/release.md).
#
# The assets are the bun-compiled static binaries release.yml publishes to the
# internal release mirror under cru/core/<version>/ (DESIGN §3.4, §7.2), the
# same files `cru update` reads. Each is a bare executable, not an
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
  version "0.2.0"

  on_macos do
    on_arm do
      url "https://mirror.corp.crucibl.internal/cru/core/0.2.0/cru-darwin-arm64"
      sha256 "86feef8f182d95e1b34a19776bea586c5a3c2c5064c656fbb2b1c331a36404cb"
    end
    on_intel do
      url "https://mirror.corp.crucibl.internal/cru/core/0.2.0/cru-darwin-x64"
      sha256 "d48b80d792c9902acc0f0432a3e05c73bbfdbb8d0191914c00fb9fbe370d12f9"
    end
  end

  on_linux do
    on_arm do
      url "https://mirror.corp.crucibl.internal/cru/core/0.2.0/cru-linux-arm64"
      sha256 "0459bef72a6bb8f6812985aca5de44ae01268af17b337fa64469980518e80001"
    end
    on_intel do
      url "https://mirror.corp.crucibl.internal/cru/core/0.2.0/cru-linux-x64"
      sha256 "37bc3b9afc8b5a53f3167b86be5171b8ffe98e469d21206187245c7b4941443c"
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
