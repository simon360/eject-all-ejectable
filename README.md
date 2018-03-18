# eject-all-ejectable

A quick-and-hacky AppleScript to eject every disk that can be ejected.

Written to make disconnecting a laptop easier. The idea: hit a keyboard shortcut, wait a couple of seconds, and safely unplug when told.

This script will read every disk that Finder reports as "ejectable", and attempts to eject them. It offers configuration options to disable ejection for specific disks, and makes its actions clear in a simple dialog after it runs.

It works well as a system-level service with a keyboard shortcut.

## Usage

### Simple usage

You can test it by opening `eject-all-ejectables.applescript` in Script Editor or [Script Debugger](https://latenightsw.com/) and hitting the ▶️ button.

### Configurable settings

At the top of the file are a number of configurable settings. You can change them as desired.

#### Safe message

**Name**: `safeMessage`

**Purpose**: Specifies the title to show on the alert dialog when all ejectable disks were ejected.

**Default**: `"Safe to disconnect"`

#### Fail message

**Name**: `failMessage`

**Purpose**: Specifies the title to show on the alert dialog when one or more disks failed to eject.

**Default**: `"Some disks did not eject"`

#### Show skipped

**Name**: `showSkipped`

**Purpose**: Show a line in the alert dialog listing disks which were intentionally not ejected.

**Default**: `false`

#### Drives to skip

**Name**: `drivesToSkip`

**Purpose**: A list of disk names which should not be ejected, even if Finder reports that they're ejectable. This may be useful for network drives, SuperDrives, SD cards, or some internal drives.

**Default**: `{}`

**Examples**:

```
set drivesToSkip to {"External file storage"}
set drivesToSkip to {"Some network location", "SDCARD"}
```

### Adding as a service

This script is most useful as a system-level service, which you can use by invoking a global keyboard shortcut (like `⌃⌘⌥E`) to quickly untether from your desk.

Unfortunately, this is a bit complicated to set up.

#### Add as a service using Automator

1. Open Automator and create a new document
2. Select `Service` as your document type
3. At the top of the editor area, ensure that the following dropdowns are set:
  * `Service receives selected` to `no input`
  * `in` to `any application`
4. On the left-hand side, search for "Run AppleScript". Drag the result into the editor area.
5. Set the text area that appears to read (replacing the comment by copying-and-pasting):
```
on run
  -- Replace this comment with the content of eject-all-ejectable.applescript. Remove any `use` lines at the start.
end run
```
6. Save the service. I recommend the name "Eject all disks"

#### Adding a global keyboard shortcut
1. Open System Preferences
2. Go to `Security & Privacy`
3. Under `Privacy`, select `Accessibility`.
4. Click the padlock to unlock, if it's locked.
5. Hit +. Add `Automator` from your `/Applications` directory
6. Hit + again. Hit `⇧⌘G`, and browse to `/System/Library/CoreServices`. Select `Finder`
7. Go back to the home of System Preferences. Select `Keyboard`.
8. Select `Shortcuts`
9. On the left, select `Services`
10. Hunt-and-peck for the "Eject all disks" item on the right. It will probably be under General.
11. Ensure that the checkbox is checked.
12. Select a keyboard shortcut by double clicking the area to the right of the title, and pressing the keyboard combination you want to use. I recommend `⌃⌘⌥E`.
13. Log out and log in again.
14. Pray to the Apple gods that they have blessed you on this day, and will allow you to proceed without frustration
15. Press `⌃⌘⌥E` (or whichever keyboard combination) you selected. Your disks should eject, and an alert should appear.

Obviously, this is not ideal.
