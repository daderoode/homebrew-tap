class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.1.0/space-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "8467e648b7f6b2cdb3fcb143687eaabb7c80a608d7ca5ab5ace8198ec6e00ec1"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.1.0/space-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "4718b6cb9204229d0f5fe5f4a6262f93667e56c16b8e15dd13669de63bb11e35"
    end
  end

  def install
    bin.install "space"
  end

  def caveats
    <<~EOS
      Add the shell wrapper to your ~/.zshrc so `space go` can change directories:

        space() {
          local out
          out=$(command space "$@")
          if [[ $out == __SPACE_CD__:* ]]; then
            cd "${out#__SPACE_CD__:}"
          else
            echo "$out"
          fi
        }

      Then generate completions:

        space completions zsh > ~/.zfunc/_space
    EOS
  end

  test do
    system "#{bin}/space", "--version"
  end
end
