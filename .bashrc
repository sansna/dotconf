# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "`dircolors`"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

function __rfc {
    w3m http://www.ietf.org/rfc/rfc$*.txt
}

alias ls="ls --color=auto"
alias ll="ls -al --color=auto"
alias l.="ls -d .* --color=auto"
alias lc="ls -d *.c --color=auto"
alias c="chromium-browser"
alias cu="cd .."
alias chromium-browser="chromium-browser --ppapi-flash-path=/usr/lib/chromium-browser/plugins/libpepflashplayer.so --ppapi-flash-version=21.0.0.182-r1 -password-store=detect -user-data-dir"
alias e="xdg-open ."
alias m="cd /usr/mf/"
alias s="shutdown now"
alias w="w3m https://www.google.com.sg"
alias wr="__rfc"
xrdb ~/.Xresources
stty -ixon ixany
