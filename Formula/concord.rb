class Concord < Formula
  desc "A terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  version "2.5.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.5.16/concord-aarch64-apple-darwin.tar.xz"
      sha256 "642bb5e7c3d3f101c7a1523105ce485bcf8f34592244bcbaa4c021ba77e48204"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.5.16/concord-x86_64-apple-darwin.tar.xz"
      sha256 "e74a9f7e8de818a30a24d0ad0e937a3bff3dba3eebad20bdc763cf049585605a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.5.16/concord-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ec08943f58c94034174f5fbe094fb1895d527bdc356838ace83846d6bede913b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.5.16/concord-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "df3d766fa44c0a002044c87f10fd10355f5155ecce92b8bc625cde0f3cc87c53"
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
