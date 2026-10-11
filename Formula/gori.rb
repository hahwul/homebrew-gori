# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.8.1"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.8.1/gori-v0.8.1-osx-arm64.tar.gz"
      sha256 "9481913377594ea30485cfc6aced738c4019d99cf3d6254b8eab778b64aa8b30"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.8.1/gori-v0.8.1-osx-x86_64.tar.gz"
      sha256 "1defd7407780d4f05c1c1f65406a8c27474c0292946e19c95468f95d3fae8495"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.8.1/gori-v0.8.1-linux-arm64"
      sha256 "8034fe04fa8af1ea8bbcefa7a871f024e7acd77d4ee94ec74019c618ac7550f3"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.8.1/gori-v0.8.1-linux-x86_64"
      sha256 "35079d0dd5b3de00023987b715e3be52bb0ce4456717951425b5d43138735c58"
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
