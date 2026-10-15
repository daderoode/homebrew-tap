class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.14.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.14.0/space-v0.14.0-aarch64-apple-darwin.tar.gz"
      sha256 "0e9f8d7b89c065e497c67ab998cf932315c78ba009f674b95503e4d7b7da170d"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.14.0/space-v0.14.0-x86_64-apple-darwin.tar.gz"
      sha256 "d21d5d56e725a3ed0ccde549f4ebd0c915762d11c5577e3366f1daa1e0b3fca0"
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
