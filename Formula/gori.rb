# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.3.1"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.3.1/gori-v0.3.1-osx-arm64.tar.gz"
      sha256 "bc1c8d0a1375e26a9cdb566186f0de92219d76a9a8b964fa1ddb57d9a94f7985"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.3.1/gori-v0.3.1-osx-x86_64.tar.gz"
      sha256 "9f1caea923e0d87740880964937c548185f991b1e27e0a24822373e8e4502910"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.3.1/gori-v0.3.1-linux-arm64"
      sha256 "bea735be13074319abf2c37322977ab0af2abab36d17d9927422aacf8938b945"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.3.1/gori-v0.3.1-linux-x86_64"
      sha256 "19d5680fbc591176b346aeeea61e9e91d966ed12ffb0648874ae10f77e369f14"
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
