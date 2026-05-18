class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version ".0.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v.0.9.0/space-v.0.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "373bab83a5940a41a3e32cf4d55ee39d27b92ada7c843dc4cf0caad6c4f19cd5"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v.0.9.0/space-v.0.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "75f3ce828d0fa674c9e7b48e8bc13f3af63aeb5d5cae10e2486291805d5c8232"
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
