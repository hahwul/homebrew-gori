# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.5.0"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.5.0/gori-v0.5.0-osx-arm64.tar.gz"
      sha256 "4df787864d5311c34389bcf014ac24da94a14888465ee667a97399302fadd56d"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.5.0/gori-v0.5.0-osx-x86_64.tar.gz"
      sha256 "a13ced993b1b9ec89a6fd847c4f8e5c426bced7eeaa5750f7739b3afb49f6d85"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.5.0/gori-v0.5.0-linux-arm64"
      sha256 "0358ead6ce691c31054f0dde2e40c0ca5a224c232afa90355417b8e63ae56b9c"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.5.0/gori-v0.5.0-linux-x86_64"
      sha256 "ee70ba4550b10a5c4f5f5f6b0438388d79c17840c6cc3f6e2c12f3045cae4489"
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
