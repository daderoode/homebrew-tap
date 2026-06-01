class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.10.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.10.0/space-v0.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "11ce4b24d39b273a8846227cd1281d637ef9661160989ce46eb4593ef8932368"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.10.0/space-v0.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "cbe109a7aed3142319479532fc15eead73f0f42768520d680dfbc3b7ea0c6a7b"
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
