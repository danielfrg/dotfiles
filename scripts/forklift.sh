# Close app first

import plistlib
fp = "/Users/danielfrg/Library/Preferences/com.binarynights.ForkLift2.plist"
root = plistlib.readPlist(fp)
del root['fd']
plistlib.writePlist(root, fp)
