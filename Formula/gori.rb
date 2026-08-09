# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.3.0"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.3.0/gori-v0.3.0-osx-arm64.tar.gz"
      sha256 "c18eab0cffe294fd0029afce529139094a14cef851e35052a652c6280c55bded"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.3.0/gori-v0.3.0-osx-x86_64.tar.gz"
      sha256 "64d7e229648c82a95efb963f85e4fd90e04649bbc449ce16827026d83f3031b1"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.3.0/gori-v0.3.0-linux-arm64"
      sha256 "a1c72e28bf4729be7e9df821fcb9c0be3b6f533ddd5faa494c5b60ef5d4eb8f1"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.3.0/gori-v0.3.0-linux-x86_64"
      sha256 "4a9727f056034af0d8509f5f42f3d918a4d52f1b1f5945c0f58016eaf0fa7b51"
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
