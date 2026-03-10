class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.2.0/space-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "0a8ba8a43827125d6c610305bdbb35797bb5d9b3315be8b46660c16634421633"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.2.0/space-v0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "f1e7b58dba39bde36e55d545dd927cf0f08bc71292ba0b34fd309bc519d06d86"
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
