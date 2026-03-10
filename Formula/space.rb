class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.3.0/space-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "51e92bc756ca647299194a9166fe4b08a9fcb3c67067c67c3c20cf2289bb8dc4"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.3.0/space-v0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "2ebc3f8bf0cbcc53ec5b1decb6600c7f15659c5d846bea6fa5a561fdfe62d42b"
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
