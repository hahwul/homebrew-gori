# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.7.1"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.7.1/gori-v0.7.1-osx-arm64.tar.gz"
      sha256 "52fe954cec1abf3e2d170c5bfbc1e426e89fdccf81505f1847e01ce055608da4"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.7.1/gori-v0.7.1-osx-x86_64.tar.gz"
      sha256 "72ed45b57dc83ac787fee791c28ce5a1137fe650cf31444e028666eeb5032ec8"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.7.1/gori-v0.7.1-linux-arm64"
      sha256 "a690646af2db8cad8ba66596a01aeedaa7c9b85f56328a78fee83e70e963334d"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.7.1/gori-v0.7.1-linux-x86_64"
      sha256 "5ddeffe1c3e5fdfca6f57b4c891e4f5dccbe42c6e0f86a889c489466f1314c6f"
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
