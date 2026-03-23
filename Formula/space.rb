class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.4.0/space-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "9199727efcaf5f19410ad6745e002b82c003f697886431b0f3d183ddf3c332b1"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.4.0/space-v0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "188f4f01f4b5a4f29f94bb0d8ea6c75971dfe5f80c56bdcf7f572984ca025848"
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
