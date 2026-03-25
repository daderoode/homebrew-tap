class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.4.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.4.1/space-v0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "404dcb3588a4104f5680fd9d34446513329b354c094043ce14f5e93c64001648"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.4.1/space-v0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "be5ebaa0149b052300aa63cadaf9a910f84f986950f61d00b8b7d769ffb16863"
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
