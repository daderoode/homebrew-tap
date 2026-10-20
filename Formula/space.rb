class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.15.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.15.0/space-v0.15.0-aarch64-apple-darwin.tar.gz"
      sha256 "805ef9ee4181ba85940b42bb626a20279e6dbbe7a38ccad8ed0b2180abe13bcf"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.15.0/space-v0.15.0-x86_64-apple-darwin.tar.gz"
      sha256 "e02855db0b1d79a0d76f58cb5118c4400cd9971850a09d257fda24bf9a60b8ce"
    end
  end

  def install
    bin.install "space"
    output = Utils.safe_popen_read(bin/"space", "completions", "zsh")
    odie "space completions zsh produced no output" if output.strip.empty?
    (zsh_completion/"_space").write output
  end

  def caveats
    <<~EOS
      Add to your ~/.zshrc to enable `space go` directory changing and TUI rendering:

        eval "$(space init zsh)"

      Completions are installed to Homebrew's zsh site-functions directory.
      If you use Homebrew's zsh or have configured $fpath to include it,
      tab completion works without any extra steps.
    EOS
  end

  test do
    system "\#{bin}/space", "--version"
  end
end
