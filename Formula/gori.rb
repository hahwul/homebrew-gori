# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.3.2"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.3.2/gori-v0.3.2-osx-arm64.tar.gz"
      sha256 "96d179a18de0ef792a10f629dae69d6a934287a73e522462a8067ffc7e047c4f"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.3.2/gori-v0.3.2-osx-x86_64.tar.gz"
      sha256 "b0f4b3d69e83e3e60ccfb94741f865a484588e420534117e359a21978125aea2"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.3.2/gori-v0.3.2-linux-arm64"
      sha256 "b0fb47ff35e2a2906a11e81027d4267fee8897d07b5501a5220c037a88ef2d35"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.3.2/gori-v0.3.2-linux-x86_64"
      sha256 "d14357b15e2ea87eedd1e793fad5a47bddfe5620ea8c8699236abc65c433f5e3"
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
