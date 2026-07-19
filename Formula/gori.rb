# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.1.0"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.1.0/gori-v0.1.0-osx-arm64.tar.gz"
      sha256 "a213edbb0d59aa27dc7603669803e790c8c5293538ea1e1a8371a92e8cd40a29"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.1.0/gori-v0.1.0-osx-x86_64.tar.gz"
      sha256 "d70a2c53ec4adac70e46dbfa8d721f761d43118cfe544a67c1bdf00e4c2939cf"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.1.0/gori-v0.1.0-linux-arm64"
      sha256 "7a1911d63d3f006e949348b2c525b2dd94a356971a19e12b799ca1e952c85891"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.1.0/gori-v0.1.0-linux-x86_64"
      sha256 "5924b51066b34b362bc85458132a7ad1de46aeb178c77fce7c0e8908e02d103b"
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
