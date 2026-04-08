class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.6.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.6.1/space-v0.6.1-aarch64-apple-darwin.tar.gz"
      sha256 "94b23bb13a6d306bca610cf8bd2817addb8fa781889ce0c38ff10c110b7dfd29"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.6.1/space-v0.6.1-x86_64-apple-darwin.tar.gz"
      sha256 "d064c53c50283faa918857099c7f0b3bec212aa364e4cec288f825153cffe442"
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
