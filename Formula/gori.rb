# typed: strict
# frozen_string_literal: true

# This file is rendered by gori's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Gori < Formula
  desc "TUI web proxy (MITM) for inspecting, intercepting and replaying HTTP traffic"
  homepage "https://github.com/hahwul/gori"
  version "0.9.2"
  license "Apache-2.0"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL, brotli, zstd, libyaml, gmp, pcre2, gc)
    # next to the binary, rewrites load paths to @executable_path/lib and re-signs
    # each image, so no brew dependency is needed. libsqlite3 is not bundled: it
    # resolves to /usr/lib/libsqlite3.dylib, which every macOS ships.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.9.2/gori-v0.9.2-osx-arm64.tar.gz"
      sha256 "f0cb3cfe9be177bbdab275019292c5b1706e6bf34563c031dc2e66a98de95f06"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.9.2/gori-v0.9.2-osx-x86_64.tar.gz"
      sha256 "d4cbcd5ec38b314f244c5ded0ed1f41929c9554f0aa6afed2aaf0029f661070d"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/gori/releases/download/v0.9.2/gori-v0.9.2-linux-arm64"
      sha256 "8c030fdef8f7a6539dcf3214feef368aac05041f2ae59e3ee2b8e02702469782"
    end
    on_intel do
      url "https://github.com/hahwul/gori/releases/download/v0.9.2/gori-v0.9.2-linux-x86_64"
      sha256 "21eb1c83b952820ed91e84866b51d66b1a91a4ec2e595ef111240028c3deb40d"
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
