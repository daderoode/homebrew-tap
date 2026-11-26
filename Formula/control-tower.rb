# Rendered by packaging/render-formula.sh in daderoode/control-tower on each release.
# Edit the template there, not the copy in daderoode/homebrew-tap.
class ControlTower < Formula
  desc "Taskboard for a team of Claude Code agents in the terminal, Rex"
  homepage "https://github.com/daderoode/control-tower"
  url "https://github.com/daderoode/homebrew-tap/releases/download/control-tower-v0.6.3/tower-v0.6.3-aarch64-apple-darwin.tar.gz"
  version "0.6.3"
  sha256 "bb291eefa4d84f0ae0718e472db30f0f39f678a00dab695a4ae15d756d9466ef"

  # Built for macOS on Apple silicon only: Homebrew refuses it anywhere else, with
  # its own message, rather than install nothing. An Intel Mac keeps v0.3.1, the last
  # release with an Intel build.
  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "tower"
    # The lead skill's Claude Code marketplace. Claude records a local marketplace by the
    # path it was added with and loads its plugin in place from there, so one added through
    # opt_pkgshare follows every upgrade with no copy and no reinstall.
    pkgshare.install "claude"
    # The Rex actions for the dashboard's keys, with this prefix written in: Rex runs their
    # commands with its own PATH, which has no Homebrew in it.
    pkgshare.install "rex"
    inreplace pkgshare/"rex/control-tower.lua", "@HOMEBREW_PREFIX@", HOMEBREW_PREFIX.to_s
  end

  service do
    run [opt_bin/"tower", "watch"]
    keep_alive true
    log_path var/"log/control-tower.log"
    error_log_path var/"log/control-tower.log"
    environment_variables PATH: std_service_path_env
  end

  def caveats
    <<~EOS
      control-tower needs Rex, the terminal its team runs in. The watch finds rex on
      Homebrew's PATH; Rex keeps it in REX_BIN_DIR, which it sets in its own tabs, so
      from a Rex tab link it into Homebrew's bin:
        ln -s "$REX_BIN_DIR/rex" "#{HOMEBREW_PREFIX}/bin/rex"

      Start the stuck-worker watch as a background service (it starts at login):
        brew services start control-tower

      Keys for the dashboard in Rex: its own tab (pressed again there, back to where
      you were) and a popup over your tab. Add to ~/.config/rex/init.lua, with the
      keys you want, then run rex config reload:
        dofile("#{opt_pkgshare}/rex/control-tower.lua")
        rex.bind("<key>", "tower_space")
        rex.bind("<key>", "tower_popup")

      herdr is no longer supported: a team in herdr is not seen, and its plugin is
      gone (tower space and tower popup now serve the Rex keys above). If an older
      control-tower linked its herdr plugin, remove what it left behind:
        herdr plugin unlink control-tower
        rm -r #{var}/control-tower
      delete any key binding for the control-tower actions (space, popup) in herdr's
      config, ~/.config/herdr/config.toml, and, if you used tower space, the file it
      kept beside the board (harmless, read by nothing now):
        rm -f ~/.local/state/control-tower/board.space-from
      For a board TOWER_DB names, it is that file's name with .space-from in place
      of .db.

      The watch registers the lead skill's Claude Code marketplace at
      #{opt_pkgshare}/claude when Claude Code has no control-tower marketplace
      (or has the GitHub one). It leaves one added from a source checkout alone;
      to use the brew one instead:
        claude plugin marketplace add #{opt_pkgshare}/claude
        claude plugin install control-tower@control-tower
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tower --version")
    marketplace = JSON.parse((pkgshare/"claude/.claude-plugin/marketplace.json").read)
    refute_empty marketplace["plugins"]
    marketplace["plugins"].each do |plugin|
      assert_path_exists pkgshare/"claude"/plugin["source"]/".claude-plugin/plugin.json"
    end
    assert_path_exists pkgshare/"claude/claude-plugin/skills/lead/SKILL.md"
    assert_match "tower lead hook", (pkgshare/"claude/claude-plugin/hooks/hooks.json").read
    snippet = (pkgshare/"rex/control-tower.lua").read
    assert_match "local prefix = \"#{HOMEBREW_PREFIX}\"", snippet
    refute_match "@HOMEBREW_PREFIX@", snippet
  end
end
