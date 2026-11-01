# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.9.1"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.9.1/gori-v0.9.1-osx-arm64.tar.gz"
      sha256 "77eaf6edf95fd42be9b459b94a9217955b855564bfd5ccbb25585f9c9aba28cc"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.9.1/gori-v0.9.1-osx-x86_64.tar.gz"
      sha256 "2917f42beb827272ffd50a9e0dc2e11335cc5cd486ba6677ad807c64f271a3d4"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.9.1/gori-v0.9.1-linux-arm64"
      sha256 "3d3cd1f61680d7d805911d010d824d22cbdd58468b047b3baaed53b23bbc9445"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.9.1/gori-v0.9.1-linux-x86_64"
      sha256 "4e6a84ee9bf3d454306816ecc0c0cee50bcedb41e9d82c045be0b8ee813148b0"
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
