# Rendered by packaging/render-formula.sh in daderoode/control-tower on each release.
# Edit the template there, not the copy in daderoode/homebrew-tap.
class ControlTower < Formula
  desc "Taskboard for a team of Claude Code agents, as a herdr plugin"
  homepage "https://github.com/daderoode/control-tower"
  version "0.2.0"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/homebrew-tap/releases/download/control-tower-v0.2.0/tower-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "7111564c38c3df5b4b454860d1f4c9641d7475af08bb766679aab020b8c4d0c8"
    end

    on_intel do
      url "https://github.com/daderoode/homebrew-tap/releases/download/control-tower-v0.2.0/tower-v0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "cc31b7ac5ab0fb22220979e1a8e302c0d6fca7fbd4b4308751767321f0d9dc17"
    end
  end

  def install
    bin.install "tower"
    # The repo's dev manifest builds with cargo and runs ./target/release/tower, for its pane
    # and its actions. The installed manifest drops the build step and runs the installed
    # binary by absolute path.
    pkgshare.install "herdr-plugin.toml"
    inreplace pkgshare/"herdr-plugin.toml" do |s|
      s.gsub!(/^(?:#.*\n)*\[\[build\]\]\n(?:[^\[\n].*\n)*\n?/, "")
      s.gsub! "./target/release/tower", "#{opt_bin}/tower"
    end
    # The lead skill's Claude Code marketplace. Claude records a local marketplace by the
    # path it was added with and loads its plugin in place from there, so one added through
    # opt_pkgshare follows every upgrade with no copy and no reinstall.
    pkgshare.install "claude"
  end

  # herdr stores a plugin's resolved path, and pkgshare resolves into the versioned Cellar
  # that `brew upgrade` deletes. var is not versioned, so herdr links there once (tower
  # links it itself when herdr has no control-tower) and every install or upgrade refreshes
  # the plugin files in place.
  def post_install
    dir = var/"control-tower"
    dir.mkpath
    cp pkgshare/"herdr-plugin.toml", dir/"herdr-plugin.toml"
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
      Start the stuck-worker watch as a background service (it starts at login):
        brew services start control-tower

      tower links its herdr plugin from #{var}/control-tower when herdr has no
      control-tower plugin yet. It leaves a linked source checkout alone; to use the
      brew one instead:
        herdr plugin unlink control-tower
        herdr plugin link #{var}/control-tower

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
    manifest = (pkgshare/"herdr-plugin.toml").read
    assert_match "#{opt_bin}/tower", manifest
    refute_match "[[build]]", manifest
    refute_match "./target/release", manifest
    marketplace = JSON.parse((pkgshare/"claude/.claude-plugin/marketplace.json").read)
    refute_empty marketplace["plugins"]
    marketplace["plugins"].each do |plugin|
      assert_path_exists pkgshare/"claude"/plugin["source"]/".claude-plugin/plugin.json"
    end
    assert_path_exists pkgshare/"claude/claude-plugin/skills/lead/SKILL.md"
    assert_match "tower lead hook", (pkgshare/"claude/claude-plugin/hooks/hooks.json").read
  end
end
