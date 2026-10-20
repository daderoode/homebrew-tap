# Rendered by packaging/render-formula.sh in daderoode/herdr-claude-dashboard on each release.
# Edit the template there, not the copy in daderoode/homebrew-tap.
class HerdrClaudeDashboard < Formula
  desc "Workstream dashboard for Claude Code sessions, as a herdr plugin"
  homepage "https://github.com/daderoode/herdr-claude-dashboard"
  version "0.1.0"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/homebrew-tap/releases/download/herdr-claude-dashboard-v0.1.0/hcd-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "657f701c3925c24fd5ebd546fe1dfac0f0f16508d74ca232370da3609fbda8be"
    end

    on_intel do
      url "https://github.com/daderoode/homebrew-tap/releases/download/herdr-claude-dashboard-v0.1.0/hcd-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "594f8f29aa178223c8421fb94534ea2b462b089f26912a968a2570b46e7a5ba9"
    end
  end

  def install
    bin.install "hcd"
    # The repo's dev manifest builds with cargo and runs ./target/release/hcd. The installed
    # manifest drops the build step and runs the installed binary by absolute path.
    pkgshare.install "herdr-plugin.toml"
    inreplace pkgshare/"herdr-plugin.toml" do |s|
      s.gsub!(/^\[\[build\]\]\n(?:[^\[\n].*\n)*\n?/, "")
      s.gsub! "./target/release/hcd", "#{opt_bin}/hcd"
    end
  end

  # herdr stores a plugin's resolved path, and pkgshare resolves into the versioned Cellar that
  # `brew upgrade` deletes. var is not versioned, so herdr links there once and every install
  # or upgrade refreshes the manifest in place.
  def post_install
    (var/"herdr-claude-dashboard").mkpath
    cp pkgshare/"herdr-plugin.toml", var/"herdr-claude-dashboard/herdr-plugin.toml"
  end

  def caveats
    <<~EOS
      hcd is now on your PATH. To run the dashboard as a herdr plugin, point herdr at the
      installed manifest (unlink first if you linked a source checkout):

        herdr plugin unlink claude-dash
        herdr plugin link #{var}/herdr-claude-dashboard
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcd --version")
    manifest = (pkgshare/"herdr-plugin.toml").read
    assert_match "#{opt_bin}/hcd", manifest
    refute_match "[[build]]", manifest
  end
end
