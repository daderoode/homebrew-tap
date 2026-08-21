class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.13.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.13.0/space-v0.13.0-aarch64-apple-darwin.tar.gz"
      sha256 "562af9c4d59265aaa2dd1359fe4a082512fc3df84fbf0976a269bda96c0ff770"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.13.0/space-v0.13.0-x86_64-apple-darwin.tar.gz"
      sha256 "deac7eaee36380b2f45def520eb75320551ccc95c51e31cebef9e93d08d2f7af"
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
