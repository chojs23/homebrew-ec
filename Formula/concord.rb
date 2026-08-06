class Concord < Formula
  desc "A terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  version "2.5.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.5.4/concord-aarch64-apple-darwin.tar.xz"
      sha256 "ce58435a4e77b1b0d0ce5e6e796b74c69903736c929b407e7f04cefc021bca51"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.5.4/concord-x86_64-apple-darwin.tar.xz"
      sha256 "1b3d105a3962ca631c817d7f7eba3109da15475234f65e429bb9d5fc0ea7c504"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.5.4/concord-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9029bde8eee191673c103e925e4e649965030f25b5005c4e6996e61857360231"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.5.4/concord-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2f3e78bf5ba6fb9da7a64098b06bfc0ad49c0327351fea2e7d4e97bc869c4522"
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
