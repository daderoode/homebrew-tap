class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.6.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.6.2/space-v0.6.2-aarch64-apple-darwin.tar.gz"
      sha256 "44c047cad09d42fec350ef71fb228898ae1e2161167c62ce33d05348b7ca5d0b"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.6.2/space-v0.6.2-x86_64-apple-darwin.tar.gz"
      sha256 "1381b3da3bc731f6a2c849bf6b11feeb475bdffcfe225becf3486fff5061c10a"
    end
  end

  def install
    bin.install "space"
  end

  def caveats
    <<~EOS
      Add the shell wrapper to your ~/.zshrc so `space go` can change directories
      and TUI commands (space, space config, space create, etc.) render correctly:

        space() {
case "${1:-}" in
  ls|list|status|st|repos|completions|--version|--help|-h|-V)
    command space "$@"
    ;;
  *)
    local cdfile="${TMPDIR:-/tmp}/.space_cd_$$"
    __SPACE_CD_FILE__="$cdfile" command space "$@"
    local ret=$?
    if [[ -s "$cdfile" ]]; then
      cd -- "$(<"$cdfile")"
    fi
    rm -f "$cdfile" 2>/dev/null
    return $ret
    ;;
esac
        }

      Then generate completions:

        space completions zsh > ~/.zfunc/_space

      NOTE: If you have an older wrapper in your ~/.zshrc, replace it with the above.
    EOS
  end

  test do
    system "\#{bin}/space", "--version"
  end
end
