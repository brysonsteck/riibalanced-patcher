# Setup the Patcher

Click your OS below to jump to the section:

* [Linux/BSD](#Linux/BSD)
* [macOS](#macOS)

There are two setup methods for Windows users:

* [WSL](#WSL) (RECOMMENDED, a little tricky to install but easy to remove)
* [Cygwin](#Cygwin) (More advanced, simple to install but difficult to remove)

## Linux/BSD

No additional setup is required. Simply install `git`, `curl`, and `bash` (which is most likely installed) with your distro's package manager, then clone the repository and run the script:

```bash
git clone https://github.com/brysonsteck/riibalanced-patcher.git
cd riibalanced-patcher
./patch_iso.sh
```

## macOS

Make sure the Xcode Developer Tools are installed by running the following command in Terminal:

```
xcode-select --install
```

Then simply clone the repository and run the script in Terminal. It does not matter if your default shell is `zsh`; macOS will notice to run `bash` on the script:

```bash
git clone https://github.com/brysonsteck/riibalanced-patcher.git
cd riibalanced-patcher
./patch_iso.sh
```

## Windows - WSL

**This is the RECOMMENDED way to use the patcher on Windows.**

### Installing WSL

You can skip to [Running the patcher on WSL](#Running_the_patcher_on_wsl) if you already have a WSL distro installed.

To install WSL, you need to have Windows 10 with build 19041 or higher, or Windows 11. To check your Windows 10 build, run `winver` in Command Prompt. If you cannot/refuse to update to such versions, you can try using the [Cygwin](#Cygwin) method to run the patcher.

Open a Command Prompt as Administrator and type:

```
wsl --install -d Debian
```

This will install WSL and the other necessary software before prompting you to reboot. WSL is basically a Linux virtual machine baked into Windows.

Upon reboot, Windows should automatically continue the installation after logging in. If it does not, you may have to nudge it by typing `wsl` in Command Prompt and hitting ENTER. After it does install, it will ask you for a UNIX username and password. These two things do not have to be the same as your Windows login, but remember your password as it is necessary to install software in the WSL machine. Upon completing your user setup, run the following:

```
sudo apt update && sudo apt upgrade
```

Your "sudo password" is the password you used to create your UNIX account. Upon running this command, move forward to the next section.

### Running the patcher on WSL

Install `git`, `curl`, and `bash`. If you installed WSL using the guide above, you would simply type the command below to do so (`bash` is already installed):

```
sudo apt install git curl
```

Once the install is complete, you can clone the repository and run the script:
```bash
git clone https://github.com/brysonsteck/riibalanced-patcher.git
cd riibalanced-patcher
./patch_iso.sh
```

Transferring files between WSL and Windows can be done by using File Explorer (in Windows 11 and in more recent builds of Windows 10) or navigating to the `/mnt/c` directory within WSL and using `cp` or `mv`.

### Uninstalling WSL

If you only wanted to run this patcher once, you can simply uninstall it by running the following in Command Prompt:

```
wsl --unregister Debian
```

## Windows - Cygwin

### Installing Cygwin

These instructions are accurate as of setup version 2.918. **Do not follow these instructions if you have installed a WSL distro.**

You can skip to [Running the patcher on Cygwin](#Running_the_patcher_on_Cygwin) if you already have Cygwin installed.

To install Cygwin, you need to [download the installer]() from the Cygwin website. Upon downloading, run the program. 

When it asks to choose a download source, choose "Install from Internet" and click next.

You can change the install direcotry if you wish, including installing for all users or just yourself.

You can leave alone where it asks to select the local package directory, this is a temporary folder during installation.

Setup the proxy if your internet requires.

You will then be asked for the mirror/"download site". You can usually chose the top-most item on the list and be fine.

A window will appear asking what software you want installed. Use the search bar or browse the submenus for an item called `git` and install it by selecting it in the submenu on the right of the table entry, then you can click "Next" leaving everything defaulted. This may take a few minutes depending on your disk speed and internet connection.

Once everything has downloaded, you can add shortcuts on the desktop or Start Menu if you wish before clicking "Finish".

### Running the patcher on Cygwin

Start Cygwin by using the shortcut(s) you made or by running the batch file where you installed it (probably `C:\cygwin64`), then you can clone the repository and run the script:

```bash
git clone https://github.com/brysonsteck/riibalanced-patcher.git
cd riibalanced-patcher
./patch_iso.sh
```

Transferring files between Cygwin and Windows can be done by copying files to the desired directory within the Cygwin install (probably `C:\cygwin64`).

### Uninstalling Cygwin

If you only wanted to run this patcher once, you may be stuck with Cygwin unless you want to go through a tedious removal process. Cygwin unfortunately does not come with an uninstaller and cannot be uninstalled through Control Panel or Windows Settings. You can follow the official FAQ guide on the [Cygwin website](https://www.cygwin.com/faq.html#faq.setup.uninstall-all) to uninstall it completely.
