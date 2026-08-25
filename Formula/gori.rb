# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.4.0"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.4.0/gori-v0.4.0-osx-arm64.tar.gz"
      sha256 "4570d00884658f72265743756739c5e83d0d8777e022ae794d9abc35e8272db4"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.4.0/gori-v0.4.0-osx-x86_64.tar.gz"
      sha256 "d9161f65952d773afc16e4697575fcb6c84d46c8ef56aab41aa5524e25e04f8b"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.4.0/gori-v0.4.0-linux-arm64"
      sha256 "3421e328daf6a67fa42b8e9602f7d62eee02654508d49632971d3f063ca1e948"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.4.0/gori-v0.4.0-linux-x86_64"
      sha256 "3e6bbc22b0ee9c72743861d6633baf6e11d3ed9fe2f7e61c9806e8644d947c04"
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
