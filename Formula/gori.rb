# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.9.3"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.9.3/gori-v0.9.3-osx-arm64.tar.gz"
      sha256 "2e4603528b9f3a3fc7371056ddf00c5d47f1799c0e1733735d0b5c8bba5dcef2"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.9.3/gori-v0.9.3-osx-x86_64.tar.gz"
      sha256 "a4e69742a80be3fbfb080f98a5bfc631b1e951e57e559b231b085642cb13752a"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.9.3/gori-v0.9.3-linux-arm64"
      sha256 "4d9eda71366715aa9142fd46b90cb1a7c7589b0506e90f609c3f10c9d45693c2"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.9.3/gori-v0.9.3-linux-x86_64"
      sha256 "cfe4272c81651ce38e6a0afb340cee14fbe7b7418a081a7022a657803d04825c"
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
