# Riibalanced ISO Patcher

A simple shell script that takes the Riibalanced Patch Files and builds a WBFS image that can be used in Dolphin for Netplay or simply enjoyment.

## How to use

You need three things before starting:

1. A computer system running:
  * Linux/BSD with `bash` installed
  * macOS
  * ~~Windows with [Cygwin](https://www.cygwin.com/)~~ (Not Implemented) or [WSL](https://docs.microsoft.com/en-us/windows/wsl/install)
2. A Mario Kart Wii image in ISO, WBFS, WDF, WIA, CISO, WBI, or GCZ format. (Obtained legally, of course)
3. The Riibalanced Patch Archive (This can be downloaded via the Riibalanced Discord Server)

After that, clone the repository and run the script:
```
git clone https://github.com/brysonsteck/riibalanced-patcher.git
cd riibalanced-patcher
./patch_iso.sh
```
The script will guide you on what you need to do in order for the pather to work correctly.

## Current Issues with the Patcher

* Main Menu button videos do not appear
  * This could be because there is a file referenced in the patch's Riivolution XML, but doesn't exist.
* Running the resulting image in Dolphin on Windows has the issue above, however, running the resulting image in Dolphin on Linux and macOS(?) does not have this issue for some reason.
* The resulting image does not work on original hardware.
  * For whatever reason, the game does not make it past any selection made on the Main Menu before crashing at the black loading screen.
  * The game also crashes if you try to wait for the trailer at the "Press the A button" screen, showing a white screen before crashing. 
