# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

#---- User Added ----
# Set coloured prompt
PS1='\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\$ '
# Set terminal title
PS1="\[\e]0;$\u@\h: \w\a\]$PS1"

# Configuration for xsecurelock
export XSECURELOCK_BACKGROUND_COLOR=#111111
export XSECURELOCK_AUTH_BACKGROUND_COLOR=#222222
export XSECURELOCK_AUTH_FOREGROUND_COLOR=#dddddd
export XSECURELOCK_COMPOSITE_OBSCURER=0

# Use bat to pretty paginated output
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
