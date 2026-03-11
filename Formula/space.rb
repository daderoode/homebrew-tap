class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.3.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.3.1/space-v0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "bd8034c6e0edcda2a0115429dd234b55ec36426fefcf9d8ab4f32a2800a4edfb"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.3.1/space-v0.3.1-x86_64-apple-darwin.tar.gz"
      sha256 "638190c60973df2d90a589d53e11064ac9834a24bf11e03e031bd082968955bd"
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
    system "#{bin}/space", "--version"
  end
end
