# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.7.0"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.7.0/gori-v0.7.0-osx-arm64.tar.gz"
      sha256 "6bf1e1828e011c51b34e4081a49be1ea4c523d9f9a07b05b5ad6547374e1d798"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.7.0/gori-v0.7.0-osx-x86_64.tar.gz"
      sha256 "9688b37d8b80cda6b20f9d4b95d3ea284b6f9732c799110022af4b0f1345a97d"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.7.0/gori-v0.7.0-linux-arm64"
      sha256 "38cb61b8befa0fafb926cfad5ab068da91f8ac8b9fc6190975444acab976204c"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.7.0/gori-v0.7.0-linux-x86_64"
      sha256 "f11850f681e22ecc9b4fedde1c779acd82bcf04165b69990d1784dfb0fb4bf2f"
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
