# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
#ttyid__=`tty|awk -vRS='/' '{print $1}'| grep -e '[0-9]'`
# Debian prompt:
#PS1='${debian_chroot:+($debian_chroot)}\u@\h#$ttyid__:\W\\$ '
# CentOS prompt:
#PS1="[\u@\h#$ttyid__ \W]\\$ "
#unset ttyid__
# The following is used when -x is set in debugging the bash scripts.
#PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
#umask 022
export GPG_TTY=$(tty)

# After executing each bach command, the following content will be executed.
#PROMPT_COMMAND="date"

# The following is used in Gentoo to specify default editor. Otherwise
#+ would be nano.
#EDITOR='/usr/share/vim'

# The following distinguishes filename globbing between lowercase and
#+ uppercase letters in a character range between brackets.
export LC_COLLATE=C

# The following prevent python from warning ascii codec can't decode 
#+ unicode.
#export LC_ALL=C

# The Golang paths
[ "x$GOPATH" == "x" ] &&\
    export GOPATH=~/GO\
    export PATH=$PATH:$GOPATH/bin

# In case bash-completion not load itself:
#+ File exist check. [ -s file ]
[ "x$bashcomplete__" == "x1" ]\
    || ([ -s /usr/share/bash-completion/bash_completion ]\
    && source /usr/share/bash-completion/bash_completion\
    && export bashcomplete__=1)

# The following specifies TERM for cur-bash window.
#export TERM=rxvt-unicode-256color

# Before using alias, one thing should know is that:
# aliases just replaces defined chars.. It has no idea of params..
# So if need to pass params in bash.. Use alias to define functions,
# instead, please.
unalias -a

# base-16 color scheme, see chriskempson/base16-shell
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1"  ] && [ -s $BASE16_SHELL/profile_helper.sh  ] && eval "$($BASE16_SHELL/profile_helper.sh)"
[ $? == 0 ] && base16_tomorrow-night

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "`dircolors`"
#alias ls='ls $LS_OPTIONS'
#alias ll='ls $LS_OPTIONS -l'
#alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
#alias rm='rm -i'
#alias cp='cp -i'
#alias mv='mv -i'

alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias pcregrep="pcre2grep --color=auto"

function __cd {
    tmpdir__=$*
    [ "x$tmpdir__" == "x" ]\
        && cd\
        || cd "${tmpdir__}"
    ls;wordcount__=`ls -a|wc -w`
    [ $wordcount__ -eq 2 ] && echo "No Entries in this Folder."
    unset wordcount__;
    unset tmpdir__
}
# Functons to be called in bash -c or xargs should be exported in this way.
export -f __cd

function __cu {
    [ "x$HOME" == "x" ]\
        && printf "Please set \$HOME first.\n"\
        && return 1
    [ "x$1" == "x" ] \
        && cd ..\
        || ([ $1 -ge 0 ] \
            && for i in `seq $1`; do cd ..; done\
            && echo `pwd`>${HOME}/cdtmpfile__)
    [ -e ${HOME}/cdtmpfile__ ]\
        && location__=`cat ${HOME}/cdtmpfile__`\
        && rm ${HOME}/cdtmpfile__\
        && cd $location__\
        && unset location__
    ls
}
alias cd="__cd"
alias cu="__cu"

# Using function for alias because needs parameter.
function __w {
    [ "x$*" == "x" ] \
        && (w3m https://www.google.com/ncr; return 0 )\
        || (website__=$(sed "s/\ /+/g"<<<$*)\
            && w3m https://www.google.com/search?ie=ISO-8859-1\&hl=en\&source=hp\&biw=\&bih=\&q=${website__}\&btnG=Google+Search\&gbv=1)
    unset website__
}

function __rfc {
    w3m http://www.ietf.org/rfc/rfc$*.txt
}

function __we {
    w3m https://en.wikipedia.org/wiki/$*
}

function __wk {
    w3m http://www.kernel.org/doc
}

function __i {
    pandoc "$1"|w3m -T text/html
}

function __sgs {
    grep $1 -rl . | xargs -d '\n' sed -i".bak" "s/$1/$2/g"
}

function __sgsl {
    find . -maxdepth 1 -type f|xargs -d '\n' grep $1 -l |xargs -d '\n' sed -i".bak" "s/$1/$2/g"
}

#alias ct="cp -t ~/test/"
alias lgf="find . -type f|grep"
alias lgd="find . -type d|grep"
alias lgl="find . -type l|grep"
alias lgb="find . |grep .bak$"
alias lgfl="find . -maxdepth 1 -type f|grep"
alias lgdl="find . -maxdepth 1 -type d|grep"
alias lgll="find . -maxdepth 1 -type l|grep"
alias lgbl="find . -maxdepth 1 |grep .bak$"

# Do much same as what xargs do? So change to nts.
#alias nt0="awk -vORS='\0' '{print \$0}'"
alias nts="awk -vORS='\ ' '{print \$0}'"

#Remove current dir
function __rcd {
    filecount__=`ls -a|wc -w`;
    filecount__=$((filecount__-2))
    foldername__=`pwd`
    [ "$1" == "-f" ] \
        && cd ..\
        && rm -frd $foldername__\
        && unset foldername__\
        && unset filecount__\
        && ls\
        && return 0
    [ $filecount__ -eq 0 ] \
        && rm -frd $foldername__ \
        && cd ..\
        && ls\
        || printf "Note: Current folder has %d sub-contents.\
 Use 'rcd -f' instead.\n" $filecount__
    unset foldername__
    unset filecount__
    return 0
}

function __rgf {
    lgf $1|xargs -d "\n" rm -f
}

function __rgd {
    lgd $1|xargs -d "\n" rm -frd
}

function __rgl {
    lgl $1|xargs -d "\n" rm -frd
}

function __rgb {
    lgb|xargs -d "\n" rm -frd
}

function __rgbl {
    lgbl|xargs -d "\n" rm -frd
}

function __rgfl {
    lgfl $1|xargs -d "\n" rm -f
}

function __rgdl {
    lgdl $1|xargs -d "\n" rm -frd
}

function __gt {
    mkdir -p ~/GitRepo
    [[ $1 == *"/"* ]]\
        && (git clone https://github.com/$1 ~/GitRepo/$1;return 0)\
        || (git clone https://github.com/$1/$1 ~/GitRepo/$1/$1;return 0)
}

function __gts {
    mkdir -p ~/GitRepo
    [[ $1 == *"/"* ]]\
        && (git clone ssh://git@github.com/$1 ~/GitRepo/$1;return 0)\
        || (git clone ssh://git@github.com/$1/$1 ~/GitRepo/$1/$1;return 0)
}

function __gush {
    commitinfo__=${@:2}
    git add -A; git commit -S -m "$commitinfo__"; git push origin $1;
    unset commitinfo__
}

function __cget {
    curl -u just:123 -o $1 ftp://10.0.2.33/$1
}

function __cput {
    curl -u just:123 -T $1 ftp://10.0.2.33/$1
}

#expr string modifier
function __cog {
    gcc -O0 -g $1 -o $(expr substr $1 1 $(expr index $1 .))out
}

function __kd {
    while true ; do
        date
        eval "$*"
        [ $? -eq 0 ] && break
    done
}

# auto update CentOS/Ubuntu/Raspbian is preferred.. However Gentoo/Arch should
#+ always update on comfirmation.. Although can also be automated by adding --no-comfirm..
function __updatesystem {
    arc__=`cat /etc/os-release |grep ^NAME|awk -vRS='\"' '{print $1}'|awk -vRS='=' '{print $1}'|grep -v NAME`
    [ "x" == "x$arc__" ] && echo "No OS detected.\n"&& return 1
    [ "CentOS" == "$arc__" ]||[ "Red" == "$arc__" ]||[ "Fedora" == "$arc__" ]&&sudo yum update &&sudo yum upgrade -y
    [ "Arch" == "$arc__" ]&&sudo pacman -Syu
    [ "Gentoo" == "$arc__" ]&&emerge --sync
    [ "Raspbian" == "$arc__" ]||[ "Ubuntu" == "$arc__" ]||[ "Debian" == "$arc__" ]&&sudo apt-get update && sudo apt-get -y upgrade
}

#function __startsshd {
#    sudo mkdir -p /var/run/sshd
#    sudo iptables -I INPUT -p tcp --dport 22 -j ACCEPT
#    sudo /usr/sbin/sshd
#}

# To modify mount dir, edit /etc/vsftpd.conf
#function __startvsftpd {
#    sudo mkdir -p -m0755 /var/run/vsftpd
#    sudo mkdir -p -m0755 /var/run/vsftpd/empty
#    sudo iptables -I INPUT -p tcp --dport 21 -j ACCEPT
#    sudo /usr/sbin/vsftpd &
#}

#function __scpp {
#    scp $1 pi@host:/home/pi/
#}

alias ll="ls -al --color=auto"
alias llh="ll -h"
alias llhd="llh -d"
alias l.="ls -d .* --color=auto"
alias lr="ls -Ra"
alias lg="ls -Ra|grep"
alias lgs="find . -type f |grep -v tags$|grep -v types_c.taghl|xargs -d '\n' grep --color=auto"
alias lgls="find . -type l |grep -v tags$|grep -v types_c.taghl|xargs -d '\n' grep --color=auto"
alias lgsl="find . -maxdepth 1 -type f |grep -v tags$|grep -v types_c.taghl |xargs -d '\n' grep --color=auto"
alias lglsl="find . -maxdepth 1 -type l |grep -v tags$|grep -v types_c.taghl|xargs -d '\n' grep --color=auto"
# Using pcre2-tools other than grep
alias pgs="find . -type f |grep -v tags$|grep -v types_c.taghl|xargs -d '\n' pcre2grep --color -sn"
# Search with perl-5 regexp support
alias pgms="find . -type f |grep -v tags$|grep -v types_c.taghl|xargs -d '\n' pcre2grep --color -snM"
alias pgls="find . -type l |grep -v tags$|grep -v types_c.taghl|xargs -d '\n' pcre2grep --color -sn"
alias pgsl="find . -maxdepth 1 -type f |grep -v tags$|grep -v types_c.taghl |xargs -d '\n' pcre2grep --color -sn"
# Search with perl-5 regexp support
alias pgmsl="find . -maxdepth 1 -type f |grep -v tags$|grep -v types_c.taghl |xargs -d '\n' pcre2grep --color -snM"
alias pglsl="find . -maxdepth 1 -type l |grep -v tags$|grep -v types_c.taghl|xargs -d '\n' pcre2grep --color -sn"
alias sgs="__sgs"
alias sgsl="__sgsl"
alias gfs="grep . -rnwe"
alias gsf="grep . -rlnwe"

#grep certain extension: Command concat, from 2nd arg to last.
function __gesf {
    ext__="--include=\*.$1"
    arg__=${@:2}
    arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="grep ${ext__} -rl $arg__"
    eval $command__
    unset arg__
    unset command__
    unset ext__
}

function __gefs {
    ext__="--include=\*.$1"
    arg__=${@:2}
    arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="grep ${ext__} -rne $arg__"
    eval $command__
    unset arg__
    unset command__
    unset ext__
}

function __gbsf {
    ext__="--include=$1"
    arg__=${@:2}
    arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="grep ${ext__} -rl $arg__"
    eval $command__
    unset arg__
    unset command__
    unset ext__
}

function __gbfs {
    ext__="--include=$1"
    arg__=${@:2}
    arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="grep ${ext__} -rne $arg__"
    eval $command__
    unset arg__
    unset command__
    unset ext__
}

function __pesf {
    ext__="--include=\.\*\\\\.$1"
    arg__=${@:2}
    arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="pcregrep ${ext__} -rlM $arg__ ."
    eval $command__
    unset arg__
    unset command__
    unset ext__
}

function __pefs {
    ext__="--include=\.\*\\\\.$1"
    arg__=${@:2}
    arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="pcregrep ${ext__} -rnM $arg__ ."
    eval $command__
    unset arg__
    unset command__
    unset ext__
}

function __pbsf {
    ext__="--include=^$1$"
    arg__=${@:2}
    arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="pcregrep ${ext__} -rlM $arg__ ."
    eval $command__
    unset arg__
    unset command__
    unset ext__
}

function __pbfs {
    ext__="--include=^$1$"
    arg__=${@:2}
    arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="pcregrep ${ext__} -rnM $arg__ ."
    eval $command__
    unset arg__
    unset command__
    unset ext__
}

alias gesf="__gesf"
alias gefs="__gefs"
alias gbsf="__gbsf"
alias gbfs="__gbfs"

alias pesf="__pesf"
alias pefs="__pefs"
alias pbsf="__pbsf"
alias pbfs="__pbfs"

function __gtf {
    gsf ^struct\ "$1"\ \{
}

function __gcT {
    mkdir -p ~/GitRepo/Trii
    [ -d "/Trii/$1" ] && echo "Repo exists." && return 1\
                      ||( git init --bare ~/GitRepo/Trii/$1\
                          && chown -R git ~/GitRepo/Trii/$1)
}

function __gch {
    [ "x" == "x$1" ] && echo "Repo name required." && return 1\
        || curl -u 'sansna' https://api.github.com/user/repos -d "{\"name\":\"$1\"}"
}

function __getasn {
    whois -h whois.cymru.com -v $1
    whois -h whois.cymru.com " -v `dig +short $1`"
    # The following is an example of using xargs to pass complicated args.
    #dig +short $1|xargs -I{} -d "\n" whois -h whois.cymru.com -v {}
}

alias gtf="__gtf"
alias rcd="__rcd"
alias rgf="__rgf"
alias rgd="__rgd"
alias rgl="__rgl"
alias rgb="__rgb"
alias rgfl="__rgfl"
alias rgdl="__rgdl"
alias rgbl="__rgbl"
alias gr="cd ~/GitRepo"
alias grT="cd ~/GitRepo/Trii"
# The first two is used in archlinux's chromium, the second is used in raspbian
#+ in archlinux, the chromium's flash should is chromium-pepper-flash.
#alias c="chromium"
#alias chromium="chromium --ppapi-flash-path=/usr/lib/PepperFlash/libpepflashplayer.so --ppapi-flash-version=12.0.0.77 -password-store=detect -user-data-dir"
#alias c="chromium-browser"
#alias chromium-browser="chromium-browser --ppapi-flash-path=/usr/lib/chromium-browser/plugins/libpepflashplayer.so --ppapi-flash-version=21.0.0.182-r1 -password-store=detect -user-data-dir"
#alias e="xdg-open ."
#alias m="cd /usr/mf/"
alias w="__w"
alias how="w how to"
alias what="w what is"
alias difference="what the difference between"
alias def="w definition"
alias wr="__rfc"
alias wk="__wk"
alias we="__we"
alias i="__i"
alias v="vim -R"
#alias x="omxplayer"
alias gt="__gt"
alias gts="__gts"
alias gush="__gush"

function __pkz {
    [[ $1 == *"/" ]]\
        && tar cfz $(expr substr $1 1 `echo "$(expr length $1)-1"|bc`).tgz $1\
        || tar cfz $1.tgz $1/
}

alias pkz="__pkz"
alias cget="__cget"
alias cput="__cput"
alias cog="__cog"
# To add src file in other dir recursively
#alias gdbs="gdb `find /usr/local/src/debug -type d -printf '-d %p '`"
alias kd="__kd"
# The following tmux-save-session.sh is located in zsoltf/tmux-save-session
alias ts="cd ~;tmux-save-session.sh;mv sessions*.sh session.sh;cd -;"
alias us="__updatesystem"
alias ctg="ctags -R --extra=+f . /usr/include/ /usr/include/linux/ /usr/include/sys/ $*"
alias lse="find . -type f |grep -v \.git\/|perl -ne 'print \$1 if m/\.([^.\/]+)$/' | sort -u"
alias lsn="find . -type f ! -name '*.*'|grep -v \.git\/|xargs -n1 basename|sort -u"
alias ggi="\
    mv .gitignore .gitignore.bak;\
    echo '# [Exclude All Files]' >> \.gitignore;\
    echo '/**/*' >> \.gitignore;\
    echo '# [File Extensions]' >> \.gitignore;\
    lse | sed -e 's/^/!\/**\/*\./g' >> \.gitignore;\
    echo '# [Normal Files]' >> \.gitignore;\
    lsn | sed -e 's/^/!\/**\//g' >> \.gitignore"
#alias startsshd="__startsshd"
#alias startvsftpd="__startvsftpd"

# Some templates of ssh/rdesktop.
#alias sp="ssh -C user@host -pport"
#alias scpp="__scpp"
#alias rp="rdesktop -P -b -z -a 8 -x lan -u user -p passwd host:port -f -r sound:local -r clipboard:PRIMARYCLIPBOARD"
#alias sxp="ssh -X -C user@host -pport"

alias getasn="__getasn"
#alias pacman="sudo pacman"
#alias r="aria2c *.meta4"
alias gcT="__gcT"
alias gch="__gch"

function __gu {
    cd $*
    # Folder exist check. [ -d folder ]
    [ -d .git ] && git pull origin master\
        && git submodule update --init --recursive
    cd -
}
export -f __gu
alias gu="cd ~/GitRepo;find . -maxdepth 2 -type d|xargs -I{} bash -c '__gu {}'"

#function __ncs {
#	tar cf - $1|nc -l -p $2
#}
#
#function __ncc {
#	nc $*|tar xf -
#}
#
## Usage: server: ncs file port. client: ncc server port.
#alias ncs="__ncs"
#alias ncc="__ncc"

#function __exit {
#    exit
#    echo "" > ~/.bash_history
#}

#function __reboot {
#	sleep 1
#	reboot
#}

#alias exit="__exit"
#alias reboot="__reboot"

#alias gba="sudo /usr/games/mednafen /root/Downloads/sum-nigh3.gba"
#alias lk="i3lock -i ~/GitRepo/wp/emerge!.png"

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

# Chromebook mapkey Ctrl_L to win/super.
#[ $TERM == "linux" ]||xmodmap -e "remove Lock = Caps_Lock"
#[ $TERM == "linux" ]||xmodmap -e "keysym Caps_Lock = Super_L"
#[ $TERM == "linux" ]||xmodmap -e "keycode 66 = Super_L"
#[ $TERM == "linux" ]||xmodmap -e "add mod4 = Super_L"

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
#}
