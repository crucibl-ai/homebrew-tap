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
  version "0.1.2"

  on_macos do
    on_arm do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.2/cru-darwin-arm64"
      sha256 "50b2d441bd4b141f3d71618b27d59e80b773ccb20c81f3fed25bd4339891237e"
    end
    on_intel do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.2/cru-darwin-x64"
      sha256 "74ce8d7fb43a1bc2fc30a1c0179f30c846535fcfe8f1668b4bf26cd6c5ea564e"
    end
  end

  on_linux do
    on_arm do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.2/cru-linux-arm64"
      sha256 "7e3da68c8ef9009f6ab5c6e3a3ee52603d51809ccf5b3dda9673f0023186cfa1"
    end
    on_intel do
      url "https://mirror.corp.crucibl.internal/cru/core/0.1.2/cru-linux-x64"
      sha256 "f98926b0c9f7e21c3cb1574557754ebde2c5c01c0561b38711daf40002042454"
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
