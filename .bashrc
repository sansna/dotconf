# ~/.bashrc: executed by bash(1) for non-login shells.

# This function is used to load the bashrc script without the .bashrc.
unset __init
function __init {
# Start of function __init.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
#local ttyid__=`tty|gawk -vRS='/' '{print $1}'| grep -e '[0-9]'`
# Debian prompt:
#export PS1='${debian_chroot:+($debian_chroot)}\u@\h#$ttyid__:\W\\$ '
# CentOS prompt: between \033 are colored scripts
#local os_str__=`cat /etc/os-release|grep PRETTY|cut -d '=' -f 2|xargs -I{} expr substr {} 1 1`
#local default_if__=`ip r | grep default | gawk '{print $5}'`
#local ip_addr__=`ip r s t local | grep local | grep -vw lo | grep $default_if__ 2>/dev/null| gawk '{print $2}'`
#export PS1="\$RC_LAST_CMD_STAT[\u@$ip_addr__\[\033[1;36m\]$os_str__\[\033[m\]\${TERM:0:1}#$ttyid__§\$SHLVL \W]\\$ "

unset __update_cmd_stat
function __update_cmd_stat {
    local stat=$?
    [ $stat -eq 0 ]\
        && export RC_LAST_CMD_STAT="T "\
        && return $stat
    [ $stat -gt 128 ]\
        && export RC_LAST_CMD_STAT="F-`kill -l $(($stat - 128))` "\
        || export RC_LAST_CMD_STAT="F-$stat "
    return $stat
}
export -f __update_cmd_stat

# The following is used when -x is set in debugging the bash scripts.
#export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
#umask 022
export GPG_TTY=$(tty)

# First clears $PROMPT_COMMAND
export PROMPT_COMMAND=
# prompt opt in git folder
[ -s ~/GitRepo/magicmonty/bash-git-prompt/gitprompt.sh ]\
    && GIT_PROMPT_ONLY_IN_REPO=1\
    && source ~/GitRepo/magicmonty/bash-git-prompt/gitprompt.sh\

# After executing each bach command, the following content will be executed.
[ -n "$PROMPT_COMMAND" ]\
    && export PROMPT_COMMAND="__update_cmd_stat;"$PROMPT_COMMAND";"\
    || export PROMPT_COMMAND="__update_cmd_stat;"

# The following is used in Gentoo to specify default editor. Otherwise
#+ would be nano.
#export EDITOR='/usr/bin/vim'

# Manpager specify tool used in man pages viewing.
export MANPAGER="/usr/bin/less -isXmQr"

# The following distinguishes filename globbing between lowercase and
#+ uppercase letters in a character range between brackets.
export LC_COLLATE=C

# The following prevent python from warning ascii codec can't decode 
#+ unicode.
#+ Note: if this is set, vim/rxvt cannot display utf8 glyphs correctly.
#export LC_ALL=C

# This is needed in gnu-screen for utf-8 char to display correctly.
export LANG=en_US.UTF-8

# The Golang paths
[ "x$GOPATH" == "x" ] &&\
    export GOPATH=~/GO; export PATH=$PATH:$GOPATH/bin

# The Python env
export PYTHONSTARTUP=~/.pythonrc

# In case bash-completion not load itself:
#+ File exist check. [ -s file ]
#+ And to note commands enclosed in bracket will be executed in
#+ new-created-subshell.
[ "x$bashcomplete__" == "x1" ]\
    || while true; do
        [ -s /usr/share/bash-completion/bash_completion ]\
            && source /usr/share/bash-completion/bash_completion\
            && bashcomplete__=1
        break
    done

# Prepare vim plugin for vim: need internet
#[ -s /tmp/.a.tmp ]\
#   || wget https://raw.githubusercontent.com/sansna/vimrc/master/vimscripts/a.vim -O /tmp/.a.tmp --quiet
#[ -s /tmp/.b.tmp ]\
#   || wget https://raw.githubusercontent.com/sansna/vimrc/master/vimscripts/auto-pairs.vim -O /tmp/.b.tmp --quiet
#[ -s /tmp/.c.tmp ]\
#   || wget https://raw.githubusercontent.com/sansna/vimrc/master/vimscripts/boolpat.vim -O /tmp/.c.tmp --quiet
#[ -s /tmp/.d.tmp ]\
#   || wget https://raw.githubusercontent.com/sansna/vimrc/master/vimscripts/pasta.vim -O /tmp/.d.tmp --quiet
#[ -s /tmp/.e.tmp ]\
#   || wget https://raw.githubusercontent.com/sansna/vimrc/master/vimscripts/taglist.vim -O /tmp/.e.tmp --quiet

# The following specifies TERM for cur-bash window.
#[ $TERM != "screen-256color" ] || export TERM=rxvt-unicode-256color

# Before using alias, one thing should know is that:
# aliases just replaces defined chars.. It has no idea of params..
# So if need to pass params in bash.. Use alias to define functions,
# instead, please.
unalias -a

# Enable alias after sudo.
alias sudo="sudo "

# base-16 color scheme, see chriskempson/base16-shell
export BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1"  ] && [ -s $BASE16_SHELL/profile_helper.sh  ] && eval "$($BASE16_SHELL/profile_helper.sh)" 1>/dev/null 2>&1
[ $? == 0 ] && base16_tomorrow-night 1>/dev/null 2>&1

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

unset __ls
function __ls {
    # Note the following $* is intentionally not parenthesized.
    #+ Otherwise options cannot be append to this command.
    #+ If need to append files/folders with spaces to this cmd, quote them.
    \ls --color=auto $*
}
export -f __ls

unset __grep
function __grep {
    \grep --color=auto $*
}
export -f __grep

alias ls="__ls"
alias less="less -isXmQS"
alias grep="__grep"
alias pcregrep="pcre2grep --color=auto"

export RCAUTOMAXDISP__=100
unset __cd
function __cd {
    local tmpdir__=$*
    [ "x$tmpdir__" == "x" ]\
        && \cd\
        || \cd "${tmpdir__}"

    local total__=`\ls -a|wc -l`
    [ $total__ -eq 2 ]\
        && echo "No Entries in this Folder."\
        && return 0

    local visible__=`\ls |wc -l`
    if [ $visible__ -eq 0 ]; then
        [ $total__ -le $RCAUTOMAXDISP__ ]\
            && __ls -a\
            || echo "Too many .items in this Folder."
    else
        [ $visible__ -gt $RCAUTOMAXDISP__ ]\
            && echo "Too many items in this Folder."\
            || __ls
    fi

    return 0
}
# Functons to be called in bash -c or xargs should be exported in this way.
export -f __cd
alias cd="__cd"

# Use sshrc(from russell91/sshrc) other than ssh
unset __ssh
function __ssh {
    sshrc "$*"
}
export -f __ssh
alias ssh="__ssh"

# Bring basic vim shortcuts with sshrc, uncomment following in .sshrc file
#function __vim {
#   vim \
#       -c "set nocompatible| set foldcolumn=0|set diffopt=foldcolumn:2| filetype off| set path+=/usr/include| set tags=tags;| noremap <c-k> <c-w>k| noremap <c-j> <c-w>j| noremap <c-h> <c-w>h| noremap <c-l> <c-w>l| syntax on| filetype on| filetype plugin on| filetype plugin indent on|set t_ti= t_te= |set t_Co=256| set backspace=2| set cindent| set cinoptions=(0,u0,U0| set tabstop=4| set shiftwidth=4| set showtabline=0| set foldenable!| set foldmethod=indent| set autoread| set ignorecase| set smartcase| imap <c-k> <Up>| imap <c-j> <Down>| imap <c-h> <Left>| imap <c-l> <Right>| set hlsearch| set nu| set relativenumber| set laststatus=2| set cmdheight=2| set cursorline| set nowrap| set background=dark| set shortmess=atI| set guioptions-=m| set guioptions-=T| set guioptions-=r| set guioptions-=L| set encoding=utf-8| set fileencodings=utf-8,latin-1,ascii,gbk,usc-bom,cp936,Shift-JIS| set ff=unix| set fileformats=unix,dos,mac|highlight! link DiffText MatchParen| nnoremap <c-s> :w<CR>| inoremap <c-c> <ESC>| vnoremap // y/<C-r>\"<CR>N| nnoremap <c-c> :nohl<CR>:pclose<CR>| nnoremap <c-Q> :q!<CR>| let mapleader=\",\"| nnoremap <leader>g gg=G| nnoremap <leader>l /\/g<CR>jzt:nohl<CR>| nnoremap <leader>L ?\<CR>njzt:nohl<CR>| nnoremap <leader>v :68vs<CR>| nnoremap <leader>s :15sp<CR>| nnoremap <leader>S :let __line=line('.')<CR>:let __col=col('.')<CR>:w !sudo tee % 2>&1 1>/dev/null<CR>:edit!<CR><CR>:cal cursor(__line, __col)<CR>:unlet __line<CR>:unlet __col<CR>| nnoremap <leader>r :vertical resize 68<CR>| nnoremap <leader>w :set wrap!<CR>| nnoremap <leader>f :UpdateTypesFileOnly<CR>| nnoremap <leader>i :set nu!<CR>| nnoremap <leader>o :set foldenable!<CR>| nnoremap <leader>p :set relativenumber!<CR>| nnoremap <leader>j ::<C-r>=line('.')<CR>!python -m json.tool<CR>| nnoremap <leader>u :call clearmatches()<CR>| nnoremap <leader>m :!man 3 <C-R><C-W><CR><CR>| nnoremap <leader>t :TlistOpen<CR>| let g:Tlist_Auto_Highlight_Tag = 1| let g:Tlist_Tlist_Close_On_Select = 1| let g:Tlist_Compact_Format = 1| let g:Tlist_Display_Prototype = 0| let g:Tlist_Display_Tag_Scope = 1| let g:Tlist_Enable_Fold_Column = 1| let g:Tlist_Exit_OnlyWindow = 1| let g:Tlist_File_Fold_Auto_Close = 1| let g:Tlist_GainFocus_On_ToggleOpen = 0| let g:Tlist_Highlight_Tag_On_BufEnter = 1| let g:Tlist_Inc_Winwidth = 1| let g:Tlist_Process_File_Always = 0| let g:Tlist_Show_Menu = 1| let g:Tlist_Show_One_File = 1| let g:Tlist_Sort_Type = 1| let g:Tlist_Use_Right_Window = 1| let g:Tlist_Use_SingleClick = 1| let g:Tlist_WinWidth = 32| let g:Tlist_WinHeight = 12|source /tmp/.a.tmp |source /tmp/.b.tmp|source /tmp/.c.tmp |source /tmp/.d.tmp |source /tmp/.e.tmp |:nohl| nnoremap <leader>a :A<CR>|nnoremap <leader>e :set et<CR>:retab<CR>|nnoremap <leader>E :set noet<CR>:retab!<CR>| nnoremap <leader>bp :BoolPat| normal zz"\
#       $*
#}
unset __vim
function __vim {
    vim $*
}
export -f __vim
alias vd="__vim -d"

# Using function for alias because needs parameter.
unset __w
function __w {
    [ "x$*" == "x" ] \
        && (w3m https://www.google.com/ncr; return 0 )\
        || (local website__=$(sed "s/\ /+/g"<<<$*)\
            && w3m https://www.google.com/search?ie=ISO-8859-1\&hl=en\&source=hp\&biw=\&bih=\&q=${website__}\&btnG=Google+Search\&gbv=1)
}

unset __rfc
function __rfc {
    w3m http://www.ietf.org/rfc/rfc$*.txt
}

unset __we
function __we {
    w3m https://en.wikipedia.org/wiki/$*
}

unset __wk
function __wk {
    w3m http://www.kernel.org/doc
}

unset __i
function __i {
    pandoc "$1"|w3m -T text/html
}

alias wt="curl -s ip.sb|xargs -I{} curl -s -X POST -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -A 'Mozilla/5.0 \(Windows NT 10.0; Win64; x64\) AppleWebKit/537.36 \(KHTML, like Gecko\) Chrome/67.0.3396.87 Safari/537.36' -d 'ip={}' iplocation.com|cut -d ':' -f 3|cut -d '\"' -f 2|xargs -I{} curl -s wttr.in/{}|grep ° -C 4|grep -v ─ |grep -v ^$ | grep -v ^-"

# Open with longest match of file, together with line numbers.
unset __v
function __v {
    local cutfilename__=`echo $1|cut -d ';' -f 1|cut -d '(' -f 1|cut -d ')' -f 1`
    local nf__=`echo $cutfilename__|gawk -vFS=":" '{print NF}'`
    [ 1 -ge $nf__ ] && __vim -R -- "$cutfilename__" && return
    for i in `seq $nf__ -1 1`;
    do
        local filename__=`echo $cutfilename__|gawk -v count=$i -vFS=":" '{for(i=1;i<=count;i++)print $i}'|paste -sd:`;
        local line__=`echo $cutfilename__|gawk -v count=$i -vFS=":" '{print $(count+1)}'`
        [ -f "$filename__" ]\
            && local totalline__=`wc -l "$filename__"|cut -d ' ' -f 1`\
            && ([ $line__ -le $totalline__ ] 2>/dev/null && line__=+$line__ || unset line__;\
                __vim -R $line__ -- "$filename__")\
            && return
    done;
    __vim -R -- "$cutfilename__"
}
export -f __v

unset __sgs
function __sgs {
    grep "$1" -rl . | xargs -d '\n' sed -i".bak" "s/$1/$2/g"
}

unset __sgsl
function __sgsl {
    find . -maxdepth 1 -type f|xargs -d '\n' grep "$1" -l |xargs -d '\n' sed -i".bak" "s/$1/$2/g"
}

#alias ct="cp -t ~/test/"
alias lgf="find . -type f|__grep"
alias lgd="find . -type d|__grep"
alias lgl="find . -type l|__grep"
alias lgb="find . |__grep .bak$"
alias lgfl="find . -maxdepth 1 -type f|__grep"
alias lgdl="find . -maxdepth 1 -type d|__grep"
alias lgll="find . -maxdepth 1 -type l|__grep"
alias lgbl="find . -maxdepth 1 |__grep .bak$"
alias i="__i"
alias v="__v"
# Tolerate typo.
alias vv="__v"

# Do much same as what xargs do? So change to nts.
#alias nt0="gawk -vORS='\0' '{print \$0}'"
alias nts="gawk -vORS='\ ' '{print \$0}'"

unset __rndf
function __rndf {
    [ "x$*" == "x" ]\
        && local rndfregexp__="."\
        || local rndfregexp__="$*"
    local rndfcount__=`lgf $rndfregexp__|wc -l`
    [ $rndfcount__ -eq 0 ]\
        && echo "No such File Exist."\
        && return 1
    local rndfnum__=`shuf -i 1-${rndfcount__} -n 1`
    local retstr__='"'`lgf $rndfregexp__|head -n ${rndfnum__}|tail -n 1`'"'
    echo "${retstr__}"
}
export -f __rndf
alias rndf="__rndf"

unset __rndfl
function __rndfl {
    [ "x$*" == "x" ]\
        && local rndflregexp__="."\
        || local rndflregexp__="$*"
    local rndflcount__=`lgfl $rndflregexp__|wc -l`
    [ $rndflcount__ -eq 0 ]\
        && echo "No such File Exist."\
        && return 1
    local rndflnum__=`shuf -i 1-${rndflcount__} -n 1`
    local retstr__='"'`lgfl $rndflregexp__|head -n ${rndflnum__}|tail -n 1`'"'
    echo ${retstr__}
}
export -f __rndfl
alias rndfl="__rndfl"

# Remove current dir
unset __rcd
function __rcd {
    local filecount__=`ls -a|wc -w`;
    filecount__=$((filecount__-2))
    local foldername__=`pwd`
    [ "$1" == "-f" ] \
        && \cd ..\
        && rm -frd $foldername__\
        && __ls\
        && return 0
    [ $filecount__ -eq 0 ] \
        && rm -frd $foldername__ \
        && \cd ..\
        && __ls\
        || printf "Note: Current folder has %d sub-contents.\
 Use 'rcd -f' instead.\n" $filecount__
    return 0
}
export -f __rcd

unset __rgf
function __rgf {
    lgf "$1"|xargs -d "\n" rm -f
}

unset __rgd
function __rgd {
    lgd "$1"|xargs -d "\n" rm -frd
}

unset __rgl
function __rgl {
    lgl "$1"|xargs -d "\n" rm -frd
}

unset __rgb
function __rgb {
    lgb|xargs -d "\n" rm -frd
}

unset __rgbl
function __rgbl {
    lgbl|xargs -d "\n" rm -frd
}

unset __rgfl
function __rgfl {
    lgfl "$1"|xargs -d "\n" rm -f
}

unset __rgdl
function __rgdl {
    lgdl "$1"|xargs -d "\n" rm -frd
}

unset __swf
function __swf {
    [ -e $1 ] && [ -e $2 ] || return 1
    local tmp=$(date +%s)
    mv $1 $tmp
    mv $2 $1
    mv $tmp $2
}
export -f __swf

unset __gt
function __gt {
    mkdir -p ~/GitRepo
    [[ $1 == *"/"* ]]\
        && local fullname__=$1\
        || local fullname__=$1/$1
    [ "`curl -s https://github.com/$fullname__`" == 'Not Found' ]\
        || git clone https://github.com/$fullname__ ~/GitRepo/$fullname__
}
export -f __gt

unset __gts
function __gts {
    mkdir -p ~/GitRepo
    [[ $1 == *"/"* ]]\
        && local fullname__=$1\
        || local fullname__=$1/$1
    [ "`curl -s https://github.com/$fullname__`" == 'Not Found' ]\
        || git clone ssh://git@github.com/$fullname__ ~/GitRepo/$fullname__
}
export -f __gts

unset __gush
function __gush {
    local commitinfo__=${@:2}
    git add -A; git commit -S -m "$commitinfo__"; git push origin $1;
}
export -f __gush

unset __cget
function __cget {
    curl -u just:123 -o "$1" ftp://10.0.2.33/"$1"
}

unset __cput
function __cput {
    curl -u just:123 -T "$1" ftp://10.0.2.33/"$1"
}

# Expr string modifier
unset __cog
function __cog {
    gcc -O0 -g "$1" -o $(expr substr "$1" 1 $(expr index "$1" .))out
}
export -f __cog

# Now kd support option -n: no prompt for time.
unset __kd
function __kd {
    [ "x$1" == "x-n" ]\
        && while true ; do
                eval "${@:2}"
                [ $? -eq 0 ] && break
            done\
        || while true ; do
                date
                eval "$*"
                [ $? -eq 0 ] && break
            done
}
export -f __kd

# auto update CentOS/Ubuntu/Raspbian is preferred.. However Gentoo/Arch should
#+ always update on comfirmation.. Although can also be automated by adding --no-comfirm..
unset __updatesystem
function __updatesystem {
    arc__=`cat /etc/os-release |grep ^NAME|gawk -vRS='\"' '{print $1}'|gawk -vRS='=' '{print $1}'|grep -v NAME`
    [ "x" == "x$arc__" ] && echo "No OS detected.\n"&& return 1
    [ "CentOS" == "$arc__" ]||[ "Red" == "$arc__" ]||[ "Fedora" == "$arc__" ]&&sudo yum update &&sudo yum upgrade -y
    [ "Arch" == "$arc__" ]&&sudo pacman -Syu
    [ "Gentoo" == "$arc__" ]&&emerge --sync
    [ "Raspbian" == "$arc__" ]||[ "Ubuntu" == "$arc__" ]||[ "Debian" == "$arc__" ]&&sudo apt-get update && sudo apt-get -y upgrade
}
export -f __updatesystem

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
#    scp "$1" pi@host:/home/pi/
#}

alias ll="ls -al --color=auto"
alias llh="ll -h"
alias llhd="llh -d"
alias l.="ls -d .* --color=auto"
alias lr="__ls -Ra"
alias lg="ls -Ra|__grep"
alias lgs="find . -type f |grep -v tags$|grep -v types_c.taghl|xargs -d '\n' grep --color=auto -n"
alias lgls="find . -type l |grep -v tags$|grep -v types_c.taghl|xargs -d '\n' grep --color=auto"
alias lgsl="find . -maxdepth 1 -type f |grep -v tags$|grep -v types_c.taghl |xargs -d '\n' grep --color=auto -n"
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
alias gfs="__grep . -rnwe"
alias gsf="__grep . -rlnwe"

# Grep certain extension: Command concat, from 2nd arg to last.
unset __gesf
function __gesf {
    local ext__="--include=\*."$1""
    local arg__=${@:2}
    local arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="__grep ${ext__} -rl $arg__"
    eval $command__
    return 0
}
export -f __gesf

unset __gefs
function __gefs {
    local ext__="--include=\*."$1""
    local arg__=${@:2}
    local arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="__grep ${ext__} -rne $arg__"
    eval $command__
    return 0
}
export -f __gefs

unset __gbsf
function __gbsf {
    local ext__="--include=^"$1"$"
    local arg__=${@:2}
    local arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="__grep ${ext__} -rl $arg__"
    eval $command__
    return 0
}
export -f __gbsf

unset __gbfs
function __gbfs {
    local ext__="--include=^"$1"$"
    local arg__=${@:2}
    local arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="__grep ${ext__} -rne $arg__"
    eval $command__
    return 0
}
export -f __gbfs

unset __pesf
function __pesf {
    local ext__="--include=\.\*\\\\."$1""
    local arg__=${@:2}
    local arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="pcregrep ${ext__} -rlM $arg__ ."
    eval $command__
    return 0
}
export -f __pesf

unset __pefs
function __pefs {
    local ext__="--include=\.\*\\\\."$1""
    local arg__=${@:2}
    local arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="pcregrep ${ext__} -rnM $arg__ ."
    eval $command__
    return 0
}
export -f __pefs

unset __pbsf
function __pbsf {
    local ext__="--include=^"$1"$"
    local arg__=${@:2}
    local arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="pcregrep ${ext__} -rlM $arg__ ."
    eval $command__
    return 0
}
export -f __pbsf

unset __pbfs
function __pbfs {
    local ext__="--include=^"$1"$"
    local arg__=${@:2}
    local arg__=`echo $arg__|sed 's/(/\\\(/g'`
    command__="pcregrep ${ext__} -rnM $arg__ ."
    eval $command__
    return 0
}
export -f __pbfs

alias gesf="__gesf"
alias gefs="__gefs"
alias gbsf="__gbsf"
alias gbfs="__gbfs"

alias pesf="__pesf"
alias pefs="__pefs"
alias pbsf="__pbsf"
alias pbfs="__pbfs"

unset __gtf
function __gtf {
    gsf ^struct\ "$1"\ \{
}
export -f __gtf

unset __gcT
function __gcT {
    mkdir -p ~/GitRepo/Trii
    [ -d "/Trii/"$1"" ] && echo "Repo exists." && return 1\
                      ||( git init --bare ~/GitRepo/Trii/"$1"\
                          && chown -R git ~/GitRepo/Trii/"$1")
}
export -f __gcT

unset __gch
function __gch {
    [ "x" == "x$1" ] && echo "Repo name required." && return 1\
        || curl -u 'sansna' https://api.github.com/user/repos -d "{\"name\":\"$1\"}"
}
export -f __gch

unset __validate_ip4
function __validate_ip4 {
    local stats=1
    if [[ $* =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS="."
        ip=($*)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255\
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stats=$?
    fi
    return $stats
}
alias val_ip="__validate_ip4"
export -f __validate_ip4

unset __getasn
function __getasn {
    __validate_ip4 $*
    [ $? -eq 0 ]\
    && whois -h whois.cymru.com -v "$*"\
    || whois -h whois.cymru.com " -v `dig +short "$*"|xargs -I{}\
        bash -c "__validate_ip4 {} && echo {}"`"
    # The following is an example of using xargs to pass complicated args.
    #dig +short $1|xargs -I{} -d "\n" whois -h whois.cymru.com -v {}
}
export -f __getasn

#function __getsslproxy {
#   local tmp__=`curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36"\
#               -s https://sockslist.net/list/proxy-socks-5-list/|grep CDATA -A 1 -B 3  -m 2|grep 'DontGrubMe\|t_ip\|document'`
#   eval `echo $tmp__|cut -d'<' -f 1|tr -d ' '|sed 's/=/=$((/g'|sed 's/;/));/g'`
#   eval `echo $tmp__|cut -d '(' -f 2|cut -d ')' -f 1|sed 's/^/local port__=$((/g'|sed 's/$/))/g'`
#   local ip__=`echo $tmp__|cut -d '>' -f 2|cut -d '<' -f 1`
#   echo $ip__:$port__
#}
#export -f __getsslproxy

#function __writesslproxy {
#   [ -f /etc/proxychains.conf ] && sed -i '$ d' /etc/proxychains.conf\
#       && echo `__getsslproxy`|sed 's/^/socks5 /g'|sed 's/:/ /g' >> /etc/proxychains.conf
#}
#export -f __writesslproxy

#function __wspbg {
#   local sec__=600
#   [ "$1" -lt 3600 ] && [ "$1" -gt 60 ]\
#       && sec__=$1 2>/dev/null
#   __kd "while true ; do
#       __writesslproxy
#       sleep $sec__
#       return 1
#       break
#   done" &
#}
#export -f __wspbg

alias gtf="__gtf"
alias rcd="__rcd"
alias rgf="__rgf"
alias rgd="__rgd"
alias rgl="__rgl"
alias rgb="__rgb"
alias rgfl="__rgfl"
alias rgdl="__rgdl"
alias rgbl="__rgbl"
alias swf="__swf"
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
#alias x="omxplayer"
alias gt="__gt"
alias gts="__gts"
alias gush="__gush"
alias gs="git status"
alias gb="git branch"

unset __pkz
function __pkz {
    [[ $1 == *"/" ]]\
        && tar cfz $(expr substr "$1" 1 `echo "$[$(expr length "$1")-1]"`).tgz "$1"\
        || tar cfz "$1".tgz "$1"/
}
export -f __pkz

alias pkz="__pkz"
alias cget="__cget"
alias cput="__cput"
alias cog="__cog"
# To add src file in other dir recursively
#alias gdbs="gdb `find /usr/local/src/debug -type d -printf '-d %p '`"
alias pdb="python -m pdb"
alias pdb2="python2 -m pdb"
alias pdb3="python3 -m pdb"
alias kd="__kd"

unset __cu
function __cu {
    local nf__=0
    local value__=0

    [ "x$1" == "x" ] || [ $1 -ge 0 ] 2>/dev/null
    [ $? -ne 0 ]\
        && echo "param should be nonnegative integer."\
        && return 0

# Here shows how to do simple math.
    [ "x$1" == "x" ]\
        && __cd ..\
        && return\
        || nf__=$(nf__=`echo \`pwd\`|gawk -vFS="/" '{print NF}'`;\
            nf__=`echo "$[$nf__-$1]"`;\
            [ $nf__ -gt 0 ]\
                && echo `echo \`pwd\`|gawk -vFS="/" -vORS="/" -v count=$nf__ '{for(i=1;i<=count;i++)print $i}'`\
                || echo "??")

    [ "??" == "$nf__" ]\
        && while true; 
            do
                [ "x$2" == "x-n" ]\
                    || pwd;break 
            done\
        && read -n 1 -s value__\
        && __kd -n __cu $value__ -n\
        || __cd $nf__

    return 0
}
export -f __cu

alias cu="__cu"
alias cs="cu 100"

# The following tmux-save-session.sh is located in zsoltf/tmux-save-session
alias ts="\cd ~;tmux-save-session.sh;mv sessions*.sh session.sh;\cd -;"
alias us="__updatesystem"
alias ctg="ctags -R --extra=+f --exclude={.git,.svn} . /usr/include/ /usr/include/linux/ /usr/include/sys/ $*"
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

# Auto-clean login/command history through ssh.
#+ Before using this alias, ssh-copy-id to user@host is recommended.
#function __s {
#   \ssh $* -t "bash --rcfile <(curl -s https://raw.githubusercontent.com/sansna/dotconf/sshrc/.bashrc);\
#       while true; do\
#           rm -f /tmp/.vd
#           [ -s ~/.gitconfig.bak ]\
#               && mv ~/.gitconfig.bak ~/.gitconfig\
#               || rm -f ~/.gitconfig
#           rm -f /tmp/.inputrc
#           rm -frd ~/.w3m/
#           rm -f /tmp/a.vim
#           rm -f /tmp/auto-pairs.vim
#           rm -f /tmp/boolpat.vim
#           rm -f /tmp/pasta.vim
#           rm -f /tmp/taglist.vim
#           rm -f /tmp/.screenrc
#           rm -f /tmp/.lock.wt
#           rm -f ~/.ssh/known_hosts
#           cat /dev/null > /var/log/wtmp
#           cat /dev/null > ~/.bash_history
#           history -c
#           break
#       done"
#}
#export -f __s
#alias s="__s"

unset __sc
function __sc {
    export TERM=screen-256color
    screen -r
    [ $? -eq 1 ] && while true; do
        [ -s /tmp/.s.tmp ] || curl -s https://raw.githubusercontent.com/sansna/dotconf/sshrc/.screenrc > /tmp/.s.tmp
        [ $? -eq 0 ] && screen -c /tmp/.s.tmp && break
    done
    export TERM=linux
}
export -f __sc
alias sc="__sc"

unset __tm
function __tm {
    tmux at
    [ $? -eq 1 ] && tmux -f <(curl -s https://raw.githubusercontent.com/sansna/dotconf/master/tmux.conf)
}
export -f __tm
alias tm="__tm"

# Some templates of ssh/rdesktop.
#alias sp="ssh -C user@host -pport"
#alias scpp="__scpp"
#alias rp="rdesktop -P -b -z -a 8 -x lan -u user -p passwd host:port -f -r sound:local -r clipboard:PRIMARYCLIPBOARD"
#alias sxp="ssh -X -C user@host -pport"

alias getasn="__getasn"
#alias getsslpxy="__getsslproxy"
#alias wsp="__writesslproxy"
#alias wspbg="__wspbg"
#alias pacman="sudo pacman"
#alias r="aria2c *.meta4"
alias gcT="__gcT"
alias gch="__gch"

unset __gu
function __gu {
    cd "$1"
    # Folder exist check. [ -d folder ]
    [ -d .git ] && git pull origin master\
        && git submodule update --init --recursive
    \cd -
}
export -f __gu
alias gu="\cd ~/GitRepo;find . -maxdepth 2 -type d|xargs -I{} bash -c '__gu {}'"

#function __ncs {
#   tar cf - "$1"|nc -l -p $2
#}
#
#function __ncc {
#   nc $*|tar xf -
#}
#
## Usage: server: ncs file port. client: ncc server port.
#alias ncs="__ncs"
#alias ncc="__ncc"

#function __exit {
#    exit
#    echo "" > ~/.bash_history
#}
#export -f __exit

#function __reboot {
#   sleep 1
#   reboot
#}
#export -f __reboot
#alias exit="__exit"
#alias reboot="__reboot"

#alias gba="sudo /usr/games/mednafen /root/Downloads/sum-nigh3.gba"
#alias lk="i3lock -i ~/GitRepo/wp/emerge!.png"
#alias rndplay="find '`pwd`' -regex '.*\(mp3\|m4a\|ogg\|webm\)$'|mpv --vo null -shuffle -playlist /dev/fd/3 3<&0 0</dev/tty"

# This function is used on debian machines to build ss-libev, however
#+ in my tests, libev version seems not better but worse than pip version.
#function __getss {
#   __vim /etc/apt/sources.list
#   sudo apt-get update
#   sudo apt-get install git -y
#   sudo apt-get install --no-install-recommends gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake -y
#   __gt shadowsocks/shadowsocks-libev
#   cd ~/GitRepo
#   cd shadowsocks/shadowsocks-libev
#   git submodule update --init --recursive
#   {
#       export LIBSODIUM_VER=1.0.13
#       wget https://download.libsodium.org/libsodium/releases/libsodium-$LIBSODIUM_VER.tar.gz
#       tar xfv libsodium-$LIBSODIUM_VER.tar.gz
#       pushd libsodium-$LIBSODIUM_VER
#       ./configure --prefix=/usr && make -j`nproc`
#       sudo make install
#       popd
#       sudo ldconfig
#   }
#   {
#       export MBEDTLS_VER=2.6.0
#       wget https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
#       tar xfv mbedtls-$MBEDTLS_VER-gpl.tgz
#       pushd mbedtls-$MBEDTLS_VER
#       make SHARED=1 CFLAGS=-fPIC -j`nproc`
#       sudo make DESTDIR=/usr install
#       popd
#       sudo ldconfig
#   }
#   ./autogen.sh
#   ./configure; sudo make -j`nproc`; sudo make install
#   ss-server -s 0.0.0.0 -p port -k passwd -m method -t time &
#}
#export -f __getss
#alias getss="__getss"

unset __ssr
function __ssr {
    local running__=`ps aux|grep ss-local|grep -v grep`
    [ "x$running__" == "x" ]\
        && (ss-local -s serv-addr -p serv-port -k password -t time_out -u\
               -l local-port -m secret-method --plugin name --plugin-opts opts &)\
        && (polipo -c /etc/polipo/config &)\
        && alias pxy="http_proxy=http://localhost:8123"
}
export -f __ssr
alias ssr="__ssr"

# automatically detect if sslocal started and alias.
running__=`ps aux|grep ss-local|grep -v grep`
[ "x$running__" != "x" ]\
    && alias pxy="http_proxy=http://localhost:8123"
unset running__

# Disable ctrl+s functionality.
stty -ixon ixany

# Disables power saver functionality.
#xset s off -dpms

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
#ibus_exist__=`ps aux|grep ibus|grep daemon|wc -l`
#[ 0 -eq $ibus_exist__ ] && ibus-daemon -d -x
#unset ibus_exist__

# Debian Ver of apt-history:
#function apt-history(){
#    case "$1" in
#        install)
#            cat /var/log/dpkg.log | grep 'install '
#            ;;
#        upgrade|remove)
#            cat /var/log/dpkg.log | grep "$1"
#            ;;
#        rollback)
#            cat /var/log/dpkg.log | grep upgrade | \
#                grep "$2" -A10000000 | \
#                grep "$3" -B10000000 | \
#                gawk '{print $4"="$5}'
#            ;;
#        *)
#            cat /var/log/dpkg.log
#            ;;
#    esac
#}
find /tmp -maxdepth 1 -type d |grep sshrc|xargs rm -frd

# End of function __init.
}
export -f __init
__init
