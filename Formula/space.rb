class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.8.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.8.0/space-v0.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "ef9a4a27c2db6b79f1a906ca07c9f1fa88a8c1241956016bcff68ba783f72412"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.8.0/space-v0.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "7c2b0fe357b630e39e4ca90b30d793383a6423a4dcc1f49391e1051cb4558c43"
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
