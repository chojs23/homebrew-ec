class Concord < Formula
  desc "A terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  version "2.5.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.5.10/concord-aarch64-apple-darwin.tar.xz"
      sha256 "dbe22a28e6050401b93c4485b7282c1a0ab1f140dd60464a66969f672c2b33a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.5.10/concord-x86_64-apple-darwin.tar.xz"
      sha256 "1abf7a5a4b784391ba0c5c8e6f522c2ae38200b79e566b838650f28ec8262491"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.5.10/concord-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b028df04b84a059aad3ef70e8ce65ebdfadaedadfc3c3520e488a497c02aed5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.5.10/concord-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4e161e9d680729de29d7e93a888cbe0a2068555e763d59c24f65480d94fbcc04"
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
