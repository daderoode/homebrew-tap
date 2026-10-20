# Rendered by packaging/render-formula.sh in daderoode/herdr-claude-dashboard on each release.
# Edit the template there, not the copy in daderoode/homebrew-tap.
class HerdrClaudeDashboard < Formula
  desc "Workstream dashboard for Claude Code sessions, as a herdr plugin"
  homepage "https://github.com/daderoode/herdr-claude-dashboard"
  version "0.1.2"

  on_macos do
    on_arm do
      url "https://github.com/daderoode/homebrew-tap/releases/download/herdr-claude-dashboard-v0.1.2/hcd-v0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "a1563af96eda7c399a19e7a51c7d18bf9c6b87d253c004fa019db76388c2c0ed"
    end

    on_intel do
      url "https://github.com/daderoode/homebrew-tap/releases/download/herdr-claude-dashboard-v0.1.2/hcd-v0.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "974cdc86c5652f6912e970dfad2829a611546c580d6eb7ec06d38c8cd8cbdf1a"
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
