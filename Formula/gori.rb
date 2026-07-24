# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.1.4"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.1.4/gori-v0.1.4-osx-arm64.tar.gz"
      sha256 "2ac9840f65f4de092908412cf532cf47118c28b82ef02acba1a2fead61b4e466"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.1.4/gori-v0.1.4-osx-x86_64.tar.gz"
      sha256 "0d3c1d0ab55ea8fa99bedaa4710a01c0719dcc90816d213eb4e3a0f0201a3388"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.1.4/gori-v0.1.4-linux-arm64"
      sha256 "3437aa190e1597ef36521182aacd249f6af442a3c70d3b79b633364bd8863778"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.1.4/gori-v0.1.4-linux-x86_64"
      sha256 "6bac337fb477f89cde5c42cb89245c2d159e7016764e645977f452c0c894885d"
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
