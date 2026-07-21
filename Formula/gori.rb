# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.1.2"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.1.2/gori-v0.1.2-osx-arm64.tar.gz"
      sha256 "244a639065ac7780d14a84420c9a09377fe56f4223e073d7649f172e930a2bfb"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.1.2/gori-v0.1.2-osx-x86_64.tar.gz"
      sha256 "04de494388a433e3af00a07e451fdb17d173a7272a87d1e28da3da9e4f55984a"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.1.2/gori-v0.1.2-linux-arm64"
      sha256 "ef74da39d891b1092466dd0b210b403295ef7fb02d2c0fcd12501d5a88aeb139"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.1.2/gori-v0.1.2-linux-x86_64"
      sha256 "22d4239ba808e45c972b63a2592973c9b82f9181402478a94ce84ca6c590a899"
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
