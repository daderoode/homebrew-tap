class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.5.0/space-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "1e5ba148889c3165db314d1785678813fd99d5811407acd56b3e3d383ae75195"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.5.0/space-v0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "2676b5b2553ef3491a08c85a0041da73cf1e6a457509a03d9181b3507ff42db7"
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
