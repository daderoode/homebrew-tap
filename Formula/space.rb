class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.7.0/space-v0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "251a7eadd233fb1cfc433cd47bd1b9f6a8020f060d5349a8e2020c0faaaf9f28"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.7.0/space-v0.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "b4d0948c6e9d45b46eb36f21527e94cfb7f0d57eec8b741ef608b9126e076afe"
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
