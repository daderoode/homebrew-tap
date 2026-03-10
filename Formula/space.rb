class Space < Formula
  desc "Workspace manager for multi-repo git worktrees"
  homepage "https://github.com/daderoode/space"
  version "0.2.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/space/releases/download/v0.2.2/space-v0.2.2-aarch64-apple-darwin.tar.gz"
      sha256 "84e6453a66b1b66aed8018553e8bfd069008e75624daf5bdf2d64e1db1e2be43"
    end

    on_intel do
      url "https://github.com/daderoode/space/releases/download/v0.2.2/space-v0.2.2-x86_64-apple-darwin.tar.gz"
      sha256 "318e3607afd634a989c4372eada4c14186b42163f41f5809f4ba48059eb6f98c"
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
