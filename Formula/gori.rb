# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.6.0"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.6.0/gori-v0.6.0-osx-arm64.tar.gz"
      sha256 "9e6772f59a0ac9d7f0d8141c89fe7d7fa36f2d4bdfac51ea0d5e8ced58b95cbb"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.6.0/gori-v0.6.0-osx-x86_64.tar.gz"
      sha256 "f33d221d88307f3d378c471d6db494e2d74241af633ba21ca59a5f7e26096070"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.6.0/gori-v0.6.0-linux-arm64"
      sha256 "1ed9254e3905bde145f1407f96c4dabe68a10cf64a20759076079b8a31ab1252"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.6.0/gori-v0.6.0-linux-x86_64"
      sha256 "104f9464daccea8ca4b927693fee518ebc84209efd6b3b2e33e6c08f3b3519d1"
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
