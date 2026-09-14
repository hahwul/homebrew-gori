# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.6.1"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.6.1/gori-v0.6.1-osx-arm64.tar.gz"
      sha256 "3d94b6e3fd18e85542927935502771ec48b40b755aec36ff1b58bf6ef356a1c2"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.6.1/gori-v0.6.1-osx-x86_64.tar.gz"
      sha256 "8c5e31ebde6bdbec1db80fd8a55d26a44225fe538ebb0172544aa3f1030eead1"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.6.1/gori-v0.6.1-linux-arm64"
      sha256 "c7085160e72bd8d16903012c14b707a7554e07efe344c0e7f76225a37cc944b5"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.6.1/gori-v0.6.1-linux-x86_64"
      sha256 "581a77a965fd58713a9e4bb31c08faeeb24e6cb789aba22a1bba4ef0cbcc05f6"
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
