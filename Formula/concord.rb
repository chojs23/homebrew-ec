class Concord < Formula
  desc "A terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  version "2.5.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.5.5/concord-aarch64-apple-darwin.tar.xz"
      sha256 "cabe2e7a9cc70e3cd2c881facbd529b9e6daad8b80463a6c595b0dc097a0585b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.5.5/concord-x86_64-apple-darwin.tar.xz"
      sha256 "38173ceafdcf9b4eabe6500719b85e7501c9f87e553ba28aaf84d0f3af252cc6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.5.5/concord-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5abcdf5d02b3899031d54ec10e148fd31ecbba722d584e2c51df426b031ce661"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.5.5/concord-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "de732e89c79c6d2bba206633e6c605eb666309c80b670eb4ac5c6c9bd2319c5e"
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
