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

# The following prevent python from warning ascii codec can't decode 
#+ unicode.
# export LC_ALL=C

# The Golang paths
export GOPATH=~/GO
export PATH=$PATH:$GOPATH/bin

# The following specifies TERM for cur-bash window.
#export TERM=rxvt-unicode-256color

unalias -a

# base-16 color scheme, see chriskempson/base16-shell
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1"  ] && [ -s $BASE16_SHELL/profile_helper.sh  ] && eval "$($BASE16_SHELL/profile_helper.sh)"
base16_google-dark

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

function __i {
    pandoc "$1"|w3m -T text/html
}

function __sgs {
    grep $1 -rl . | xargs sed -i".bak" "s/$1/$2/g"
}

function __sgsl {
    find . -maxdepth 1 -type f|xargs grep $1 -l . | sed -i".bak" "s/$1/$2/g"
}

alias lgf="find . -type f|grep"
alias lgd="find . -type d|grep"
alias lgb="find . |grep .bak$"
alias lgfl="find . -maxdepth 1 -type f|grep"
alias lgdl="find . -maxdepth 1 -type d|grep"
alias lgbl="find . -maxdepth 1 |grep .bak$"

# Do much same as what xargs do? So change to nts.
#alias nt0="awk -vORS='\0' '{print \$0}'"
alias nts="awk -vORS='\ ' '{print \$0}'"

function __rgf {
    lgf $1|awk -vORS="\0" '{print $0}'|xargs -0 rm -i
}

function __rgd {
    lgd $1|awk -vORS="\0" '{print $0}'|xargs -0 rm -ird
}

function __rgb {
    lgb|xargs rm -ird
}

function __rgbl {
    lgbl|xargs rm -ird
}

function __rgfl {
    lgfl $1|awk -vORS="\0" '{print $0}'|xargs -0 rm -i
}

function __rgdl {
    lgdl $1|awk -vORS="\0" '{print $0}'|xargs -0 rm -ird
}

function __gt {
    mkdir -p ~/GitRepo
    git clone https://github.com/$1 ~/GitRepo/$1
}

function __gush {
    git add -A; git commit -m "$*"; git push origin master;
}

function __cget {
    curl -u just:123 -o $1 ftp://10.0.2.33/$1
}

function __cput {
    curl -u just:123 -T $1 ftp://10.0.2.33/$1
}

function __cog {
    gcc -O0 -g $1 -o $(expr substr $1 1 $(expr index $1 .))out
}

alias ll="ls -al --color=auto"
alias l.="ls -d .* --color=auto"
alias lr="ls -Ra"
alias lg="ls -Ra|grep"
alias lgs="find . -type f |grep -v tags$|grep -v types_c.taghl|xargs grep --color=auto"
alias lgsl="find . -maxdepth 1 -type f -print0|xargs -0 grep --color=auto"
alias sgs="__sgs"
alias sgsl="__sgsl"
alias gfs="grep . -rnwe"
alias gsf="grep . -rlnwe"
alias rgf="__rgf"
alias rgd="__rgd"
alias rgb="__rgb"
alias rgfl="__rgfl"
alias rgdl="__rgdl"
alias rgbl="__rgbl"
# alias c="chromium-browser"
alias cd="__cd"
alias gr="cd ~/GitRepo"
alias cu="cd .."
# alias chromium-browser="chromium-browser --ppapi-flash-path=/usr/lib/chromium-browser/plugins/libpepflashplayer.so --ppapi-flash-version=21.0.0.182-r1 -password-store=detect -user-data-dir"
# alias e="xdg-open ."
# alias m="cd /usr/mf/"
# alias s="shutdown now"
alias w="w3m https://www.google.com/ncr"
alias wr="__rfc"
alias wk="__wk"
alias i="__i"
alias gcfg="git config --global user.name sansna; git config --global user.email 1185280650@qq.com;git config --global color.ui auto"
alias gt="__gt"
alias gush="__gush"
alias cget="__cget"
alias cput="__cput"
alias cog="__cog"
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

# Uncomment the following in arch to enable ibus input method,
#+ first to install ibus as ibus/ibus-libpinyin.
#export GTK_IM_MODULE=ibus
#export XMODIFIERS=ibus
#export QT_IM_MODULE=ibus
#ibus-daemon -d -x

# Debian Ver of apt-history:
#function apt-history(){
#    case "$1" in
#        install)
#            cat /var/log/dpkg.log | grep 'install '
#            ;;
#        upgrade|remove)
#            cat /var/log/dpkg.log | grep $1
#            ;;
#        rollback)
#            cat /var/log/dpkg.log | grep upgrade | \
#                grep "$2" -A10000000 | \
#                grep "$3" -B10000000 | \
#                awk '{print $4"="$5}'
#            ;;
#        *)
#            cat /var/log/dpkg.log
#            ;;
#    esac
#
#}
