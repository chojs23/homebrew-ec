class Concord < Formula
  desc "A terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  version "2.5.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.5.7/concord-aarch64-apple-darwin.tar.xz"
      sha256 "e58b178b2cf370588488b3d37c3530c46a208c9eee3807f5905879c487753520"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.5.7/concord-x86_64-apple-darwin.tar.xz"
      sha256 "157f140f2a0c3725c613199e8210f3c396b9730d275520bd44b54246deb907b0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.5.7/concord-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ed869d00b475d16a57b9005c8401d2ffff3f906af88959994ac6832c0a26524"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.5.7/concord-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "77e594390e923691c6f41a1531b20ea2cb841c1d53abd37316e79e8fb8146a95"
    end
  end
  license "GPL-3.0-only"
  on_linux do
    depends_on "alsa-lib"
    depends_on "libva"
    depends_on "mesa"
    depends_on "pipewire"
  end

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "concord"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "concord"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "concord"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "concord"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
