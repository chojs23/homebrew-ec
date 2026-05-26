class Concord < Formula
  desc "A terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  version "2.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.1.4/concord-aarch64-apple-darwin.tar.xz"
      sha256 "0a13b559fa7ffb6c4a14d897d26375652c5784274660bc05e4e3b8b23dc8c4ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.1.4/concord-x86_64-apple-darwin.tar.xz"
      sha256 "383f3f07b243886d9c97cfd53cf275a6c1f9c9c070e9ea452884fe380a556815"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.1.4/concord-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bf471401f56b240e94a17be94eed0e21e45e50ce10ca76f0575cce3549020266"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.1.4/concord-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7bbb04e02fd2405052ddd6f7891814d3e141526c84bd801e5cfb9d6329490e35"
    end
  end
  license "GPL-3.0-only"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "concord" if OS.mac? && Hardware::CPU.arm?
    bin.install "concord" if OS.mac? && Hardware::CPU.intel?
    bin.install "concord" if OS.linux? && Hardware::CPU.arm?
    bin.install "concord" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
