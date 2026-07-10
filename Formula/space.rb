class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.11.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.11.0/space-v0.11.0-aarch64-apple-darwin.tar.gz"
      sha256 "5c3e7e411885e3b1bfaf7f74e3d4c9fe6e6b99955355e0d28528cf9ea650fc5a"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.11.0/space-v0.11.0-x86_64-apple-darwin.tar.gz"
      sha256 "65d163817a9279ee2cd87375acaf1965903548f5fe7c40812f6677c21c428c20"
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
