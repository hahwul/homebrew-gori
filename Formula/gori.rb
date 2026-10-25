# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.9.0"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.9.0/gori-v0.9.0-osx-arm64.tar.gz"
      sha256 "3825adb0dcc0323b1fd2f1156cf50f953d56c65950b6428412878027a9b908ae"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.9.0/gori-v0.9.0-osx-x86_64.tar.gz"
      sha256 "977f5bfee04241314323ec6fbd72945f3c1d33fccdeecc805bce5649b6815755"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.9.0/gori-v0.9.0-linux-arm64"
      sha256 "ebed283147fdbd0af82042775150a082a20c5e44e48fa86328559b327b1f70ae"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.9.0/gori-v0.9.0-linux-x86_64"
      sha256 "0717cf33536eecc973ff402248d45c68f433521c9bebbf4d80d9496cb580d7b4"
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
