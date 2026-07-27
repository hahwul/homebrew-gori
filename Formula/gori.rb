# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.2.0"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.2.0/gori-v0.2.0-osx-arm64.tar.gz"
      sha256 "343324d6d107334e295512fa3059d60c7be7767777f6491135654ddfa7952c48"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.2.0/gori-v0.2.0-osx-x86_64.tar.gz"
      sha256 "24ff0afaa3f34cff88d6fd08abadbbc4d4f0fbd127a9ff73de57c229cf0462ed"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.2.0/gori-v0.2.0-linux-arm64"
      sha256 "129845a113feba2948ffc4d69369ce0be47ae227554fa9f1d523cd63fff38657"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.2.0/gori-v0.2.0-linux-x86_64"
      sha256 "466f272850dbdbce2856c5c7ac9b46ff75ea546241829665be84ea1f44467e90"
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
