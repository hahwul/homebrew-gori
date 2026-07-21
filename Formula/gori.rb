# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.1.3"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.1.3/gori-v0.1.3-osx-arm64.tar.gz"
      sha256 "928480a85fba2a14c5f56c18e1ecc50a616f7ec76a6a4d7b3c546ae85147a308"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.1.3/gori-v0.1.3-osx-x86_64.tar.gz"
      sha256 "b76121c452a297a34804bc48a470e47f1b031bb8df3145243c227c415e101011"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.1.3/gori-v0.1.3-linux-arm64"
      sha256 "226c0f43f5a409d0d718a8b3df4f27fe82f1b8d9013bd1d15aa78132dabbf43a"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.1.3/gori-v0.1.3-linux-x86_64"
      sha256 "d4e952d1f62f2c35c85a3eb215ea0b244c3314eadd7bc8c22fd4e0efef9b4979"
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
