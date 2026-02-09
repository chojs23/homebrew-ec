class Ec < Formula
  desc "TUI native Git mergetool with 3 pane"
  homepage "https://github.com/chojs23/ec"
  url "https://github.com/chojs23/ec/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "66f4d10a074c9c2b8d0d4aef9008137c5d6c2f52c6baab80ddf0de19f99dddbc"
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
