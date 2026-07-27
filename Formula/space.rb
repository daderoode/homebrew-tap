class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.12.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.12.0/space-v0.12.0-aarch64-apple-darwin.tar.gz"
      sha256 "c1fe885a771d8cb305b752bb68a61a25bd69a1d89f6b311c12eff028a5cd32c4"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.12.0/space-v0.12.0-x86_64-apple-darwin.tar.gz"
      sha256 "33df4acec3c370642ea995420f4d28cc6d2994068a180e7819729509c42481dc"
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
