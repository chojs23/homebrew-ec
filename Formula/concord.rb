class Concord < Formula
  desc "A terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  version "2.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.1.6/concord-aarch64-apple-darwin.tar.xz"
      sha256 "55b1bada44b473705bb7be892ac5947d535b805979f7dbd879fee65c0ac7ec09"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.1.6/concord-x86_64-apple-darwin.tar.xz"
      sha256 "61f32143b24690fbad3515fcc99c08e117e7df7198bc1213332d71715a1b6db9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.1.6/concord-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "31b9bbd89e84e8bbfedd1622c8721c7dd77fe9abfe1fef13e1b4ebe28b9bf457"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.1.6/concord-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d00d4f99646e536318e7e8d5021eb182747b51e7063bd8f3835e50fb8a5e9ba0"
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
