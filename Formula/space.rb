class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.2.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.2.1/space-v0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "8404cab88aa1e5961325e2b4e20e1486ce2ded5ca07f051a1a780d033f6ea97a"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.2.1/space-v0.2.1-x86_64-apple-darwin.tar.gz"
      sha256 "e0d9ff41c1d0f79377b9d9355ea601145d6acae7536ab1ae213125208de782e4"
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
