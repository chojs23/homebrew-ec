class Concord < Formula
  desc "A terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  version "2.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.4.3/concord-aarch64-apple-darwin.tar.xz"
      sha256 "3f020bd538add22eba0caccb71cf14ddb4eccc75bfc296e3d40daf1ea51cf6c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.4.3/concord-x86_64-apple-darwin.tar.xz"
      sha256 "c093419f5feb31f6cfe2f478460e1e64f25cb025bb03e5f727c7f535cd76cdb8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/chojs23/concord/releases/download/v2.4.3/concord-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "95715cc3b4af8b882f90ac1c4893ea3826acfb90428a84afed9b85c085bf8ecf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chojs23/concord/releases/download/v2.4.3/concord-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1fd650aacb6d9562258941fa585854aed142dcd80a8d6de1f8dfd7e6592ac084"
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
