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

# Using function for alias because needs parameter.
function __rfc {
    w3m http://www.ietf.org/rfc/rfc$*.txt
}

function __wk {
    w3m http://www.kernel.org/doc
}

alias ls="ls --color=auto"
alias ll="ls -al --color=auto"
alias l.="ls -d .* --color=auto"
alias lr="ls -Ra"
alias lg="ls -Ra|grep"
#alias lgf="ls -Ra |awk '{print i\$0}' i=`pwd`'/'|grep"
#alias lgd="ls -FRa | grep \/\$ | sed "s:^:`pwd`/:"|grep"
alias c="chromium-browser"
alias cu="cd .."
alias chromium-browser="chromium-browser --ppapi-flash-path=/usr/lib/chromium-browser/plugins/libpepflashplayer.so --ppapi-flash-version=21.0.0.182-r1 -password-store=detect -user-data-dir"
alias e="xdg-open ."
alias m="cd /usr/mf/"
#alias s="shutdown now"
alias w="w3m https://www.google.com.sg"
alias wr="__rfc"
alias wk="__wk"
alias r="aria2c *.meta4"
alias gba="sudo /usr/games/mednafen /root/Downloads/sum-nigh3.gba"
[ $TERM == "linux" ]||xrdb ~/.Xresources
# Disable ctrl+s functionality.
stty -ixon ixany

xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "remove Control = Control_L"
xmodmap -e "keysym Caps_Lock = Control_L"
xmodmap -e "keycode 37 = Caps_Lock"
xmodmap -e "add Lock = Caps_Lock"
xmodmap -e "add Control = Control_L"
