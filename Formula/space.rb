class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.3.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.3.2/space-v0.3.2-aarch64-apple-darwin.tar.gz"
      sha256 "6f71742a1ec6ae5a0ffdfea5b98d0023f4dba33b12945570d64d574ae9d87b03"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.3.2/space-v0.3.2-x86_64-apple-darwin.tar.gz"
      sha256 "b085cce4dc08617c3f454d3bfcb70c51bceb3897a5ab00eca14e0d7c9e96a9e7"
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
