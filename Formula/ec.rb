class Ec < Formula
  desc "TUI native Git mergetool with 3 pane"
  homepage "https://github.com/chojs23/ec"
  url "https://github.com/chojs23/ec/archive/refs/tags/v0.1.4-test.tar.gz"
  sha256 "72f8293ef8a9c88d591c2b212f1eca09efef517f2997e3ac9ffee331177e7a01"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ec"
  end

  test do
    (testpath/"merged.txt").write <<~EOS
      line1
      <<<<<<< HEAD
      ours
      =======
      theirs
      >>>>>>> branch
    EOS
    shell_output("#{bin}/ec --check --merged #{testpath}/merged.txt", 1)
  end
end
