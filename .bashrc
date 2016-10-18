# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# Debian prompt:
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# CentOS prompt:
# PS1="[\u@\h \W]# "
# The following is used when -x is set in debugging the bash scripts.
# PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
# umask 022

# The following distinguishes filename globbing between lowercase and
#+ uppercase letters in a character range between brackets.
export LC_COLLATE=C

unalias -a

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

alias ls="ls --color=auto"
alias grep="grep --color=auto"

function __cd {
    cd $*;ls;
}

# Using function for alias because needs parameter.
function __rfc {
    w3m http://www.ietf.org/rfc/rfc$*.txt
}

function __wk {
    w3m http://www.kernel.org/doc
}

function __sgs {
    grep $1 -rl . | xargs sed -i".bak" "s/$1/$2/g"
}

alias lgf="find . -type f|grep"
alias lgd="find . -type d|grep"

function __rgf {
    lgf $1|awk -vORS="\0" '{print \$0}'|xargs -0 rm -f
}

function __rgd {
    lgd $1|awk -vORS="\0" '{print \$0}'|xargs -0 rm -frd
}

function __gush {
    git add -A; git commit -m "$*"; git push origin master;
}

alias ll="ls -al --color=auto"
alias l.="ls -d .* --color=auto"
alias lr="ls -Ra"
alias lg="ls -Ra|grep"
alias lgs="find . -type f -print0|xargs -0 grep --color=auto"
alias sgs="__sgs"
alias gfs="grep -rnwle"
alias rgf="__rgf"
alias rgd="__rgd"
# alias c="chromium-browser"
alias cd="__cd"
alias cu="cd .."
# alias chromium-browser="chromium-browser --ppapi-flash-path=/usr/lib/chromium-browser/plugins/libpepflashplayer.so --ppapi-flash-version=21.0.0.182-r1 -password-store=detect -user-data-dir"
# alias e="xdg-open ."
# alias m="cd /usr/mf/"
# alias s="shutdown now"
alias w="w3m https://www.google.com.sg"
alias wr="__rfc"
alias wk="__wk"
alias i="vim -O REA*"
alias gcfg="git config --global user.name sansna; git config --global user.email 1185280650@qq.com;git config --global color.ui auto"
alias gush="__gush"
# alias r="aria2c *.meta4"
# alias gba="sudo /usr/games/mednafen /root/Downloads/sum-nigh3.gba"
# Disable ctrl+s functionality.
stty -ixon ixany

#[ $TERM == "linux" ]||xrdb ~/.Xresources
#
#[ $TERM == "linux" ]||xmodmap -e "remove Lock = Caps_Lock"
#[ $TERM == "linux" ]||xmodmap -e "remove Control = Control_L"
#[ $TERM == "linux" ]||xmodmap -e "keysym Caps_Lock = Control_L"
#[ $TERM == "linux" ]||xmodmap -e "keycode 37 = Caps_Lock"
#[ $TERM == "linux" ]||xmodmap -e "add Lock = Caps_Lock"
#[ $TERM == "linux" ]||xmodmap -e "add Control = Control_L"
