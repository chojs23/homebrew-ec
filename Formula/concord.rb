class Concord < Formula
  desc "A terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  version "2.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.5.2/concord-aarch64-apple-darwin.tar.xz"
      sha256 "6056531138a8ee86255a9f1afc58ee70ca27c9df38f5e4299e9084c3616fdbce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.5.2/concord-x86_64-apple-darwin.tar.xz"
      sha256 "a43037ffc964c8832d3a2e51dbb262c2e3d3017088b2538f33c1b493661e35cc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.5.2/concord-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "803ec95cdcc51a7a234c4429ad96acc4a8a19e0207d23a6cbbce9d57e1ef0fb5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.5.2/concord-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "820a2292fb29ea35c52a77a64f947dbbb681a826541a386da07bd4fe5a4dae09"
    end
  end
  license "GPL-3.0-only"
  depends_on "opus"

  on_linux do
    depends_on "alsa-lib"
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
