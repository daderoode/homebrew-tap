class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.6.0/space-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "35e903c11ed7911ed033ab6105767a75f2440f552e5002ca19099f4005dc098a"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.6.0/space-v0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "9b641c0217ebc6e55042969323b101755d4138fac3c8226c464bef98e2db5634"
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
