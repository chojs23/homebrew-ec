class ImSwitch < Formula
  desc "CLI to switch keyboard input methods for the im-switch.nvim plugin"
  homepage "https://github.com/chojs23/im-switch.nvim"
  url "https://github.com/chojs23/im-switch.nvim/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "d808ca91192235555c906d5a05dda1b9d55164f2ac8cfb7e5c197d8741724280"
  license "MIT"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/im-switch -h")
  end
end
