# Based on Homebrew/homebrew-cask at de449c322e93dc67fee59ef77f8f6fb42fc76d6c.
cask "cleanshot@3" do
  version "3.9.4"
  sha256 "59224386ec40ed0e1de092b4f0bf061c9f91378f278c231aac302454c6ff22bf"

  url "https://updates.getcleanshot.com/v3/CleanShot-X-#{version}.dmg"
  name "CleanShot X (3.x)"
  desc "Screen capturing tool"
  homepage "https://cleanshot.com/"

  livecheck do
    skip "Pinned to the last 3.x release for an older license"
  end

  auto_updates true
  conflicts_with cask: "cleanshot"

  app "CleanShot X.app"

  uninstall quit: "pl.maketheweb.cleanshotx"

  postflight_steps do
    # Homebrew's pin does not prevent Sparkle from updating the app itself.
    run "/usr/bin/defaults",
        args: ["write", "pl.maketheweb.cleanshotx", "SUEnableAutomaticChecks", "-bool", "false"]
    run "/usr/bin/defaults",
        args: ["write", "pl.maketheweb.cleanshotx", "SUAutomaticallyUpdate", "-bool", "false"]
  end
end
