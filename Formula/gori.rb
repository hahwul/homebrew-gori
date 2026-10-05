# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.8.0"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.8.0/gori-v0.8.0-osx-arm64.tar.gz"
      sha256 "e6beccccf5fc5ade07e29a1f66f3dd6adf29aa6e9557ce9cea385b41e6ce1813"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.8.0/gori-v0.8.0-osx-x86_64.tar.gz"
      sha256 "01d385b0c37df599f88c87ff0b9c6ae4a54f00f126316843ea0ea337f6794bf2"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.8.0/gori-v0.8.0-linux-arm64"
      sha256 "76373279c9ac9bb86f64702bf2fc5a933ebecd02548ad65aa5b9458c806c6f9a"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.8.0/gori-v0.8.0-linux-x86_64"
      sha256 "fd08d6d2cf9fe153aba825d8cf54cdf82de3743dfc23ed67aeb4f79fba21a302"
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
