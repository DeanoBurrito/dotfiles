# Dotfiles

Collection of user and system-level tweaks for my personal linux setup.

Note that the setup script must be run using sudo (while logged into your regular user account).

Each of the top level dirs is used differently:
- `home/`: This is copied to the home folder of the user running the install script. Most of the config files and scripts are stored here.
- `root/`: This is copied into the root directory of the system, some system-level configs are stored here.
- `patches/`: Patch files and suckless-style config files. These are copied to relevant locations per-item (in the install script) when needed.
- `stash/`: Files acting as a cache of command output, ready to pipe into another command when initializing the system. Like the list of extensions for vscode.

I'll probably add other install scripts as I distro hop, but currently I only use fedora, so that's all there is. The install scripts are intended to run on a minimal server install, with only the absolute basic tools installed.
