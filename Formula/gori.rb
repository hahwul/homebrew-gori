# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.1.1"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.1.1/gori-v0.1.1-osx-arm64.tar.gz"
      sha256 "190975cf65b15dbb28a4e1dc7e087b53e1dbb4f6dd91a29ab94b7f6f497d0ce5"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.1.1/gori-v0.1.1-osx-x86_64.tar.gz"
      sha256 "3526b92380b8364fb754676501d730dfd327111773c21e670f5602c6ca6b8d02"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.1.1/gori-v0.1.1-linux-arm64"
      sha256 "77f7981178f20a077fe1b026f31e0b6816da905bd3fb0235ece386503ff1ef7f"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.1.1/gori-v0.1.1-linux-x86_64"
      sha256 "e5d4670f18d1b8ae290f3451db853edb65fdd9d4991cc8e25ce94810b9683ff7"
    end
  end

  def install
    if OS.mac?
      # The macOS tarball extracts to `gori` + `lib/*.dylib`. Keep them together
      # in libexec (the binary resolves dylibs via @executable_path/lib) and expose
      # the CLI through a symlink; execve canonicalizes the symlink so
      # @executable_path still points at libexec.
      libexec.install "gori", "lib"
      bin.install_symlink libexec/"gori"
    else
      bin.install Dir["gori-v#{version}-linux-*"].first => "gori"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gori --version")
  end
end
