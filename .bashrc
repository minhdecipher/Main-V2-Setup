# .bashrc

# User specific aliases and functions

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

case "$TERM" in

xterm*|rxvt*)

    PROMPT_COMMAND='audit;echo -ne "\033]0;${PWD}\007"'

    ;;

*)

    ;;

esac

case "$TERM" in
screen*)
PROMPT_COMMAND='audit;echo -ne "\033k\033\0134\033k[$(echo $(basename $(dirname $PWD))/`basename $PWD`)]\033\0134\033_$PWD\033\\"'
;;
esac

export GREP_COLOR='1;37;41'
alias grep='grep --color=auto'

alias ls='ls --color=auto'
alias l='ls -la'
alias la='ls -al'
alias rm='rm -r'

#v2 alias shortcuts
alias v2='cd /home/jaminb/v2/'
alias v2dev='cd /home/jaminb/alpha/v2-dev/'
alias ftpdir='cd /home/httpd/html/misc/int/upload'
alias nsst='tsst -qvN .'
alias bulk-minh='bulk -F -lemail:minh@decipherinc.com'

#mail some files quicker
alias m='echo "Your file is attached" | mailimp -s "See Attached File" -F'

#user scripts
alias sendbyperc='/home/jaminb/v2/temp/minh/scripts/sendbyperc/sendbyperc.py "$@"'
alias sampleSourcesBuilder='/home/jaminb/v2/temp/minh/scripts/sampleSourcesBuilder/sampleSourcesBuilder.py'
alias pypender='/home/jaminb/v2/temp/minh/scripts/pypender/pypender.py "$@"'
alias getfreq='/home/jaminb/v2/temp/minh/scripts/getfreq/getfreq.py "$@"'
alias checkOpens='/home/jaminb/v2/temp/minh/scripts/checkOpens/checkOpens.sh "$@"'
alias parseLog='/home/jaminb/v2/temp/minh/scripts/parseLog/parseLog.py "$@"'
alias languagesBuilder='/home/jaminb/v2/temp/roshan/SCRIPTS/LanguageTag/language.py'

#vim alias shortcuts
alias p='vim'
alias vim='vim -pb'

#screen alias shortcuts
alias sl="screen -ls"
alias sr="screen -dR"

function mksurvey() { 
    mkdir $1 && cd $1 && cp ~/survey.xml . && here setfolder .; 
}

CDPATH=.:~jaminb/v2
cd /home/jaminb/v2
return
