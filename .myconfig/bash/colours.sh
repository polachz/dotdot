# Foreground color codes

FG_BLACK='\033[00;30m'
FG_RED='\033[00;31m'
FG_GREEN='\033[00;32m'
FG_YELLOW='\033[00;33m'
FG_BLUE='\033[00;34m'
FG_PURPLE='\033[00;35m'
FG_CYAN='\033[00;36m'
FG_LIGHTGRAY='\033[00;37m'
FG_DARKGRAY='\033[01;30m'
FG_LRED='\033[01;31m'
FG_LGREEN='\033[01;32m'
FG_LYELLOW='\033[01;33m'
FG_LBLUE='\033[01;34m'
FG_LPURPLE='\033[01;35m'
FG_LCYAN='\033[01;36m'
FG_WHITE='\033[01;37m'

#Reset text color to default
FG_NO_COLOR='\033[00;39m'

#Background color codes

BG_BLACK='\033[00;40m'
BG_RED='\033[00;41m'
BG_GREEN='\033[00;42m'
BG_YELLOW='\033[00;43m'
BG_BLUE='\033[00;44m'
BG_PURPLE='\033[00;45m'
BG_CYAN='\033[00;46m'
BG_LIGHTGRAY='\033[00;47m'
BG_DARKGRAY='\033[01;40m'
BG_LRED='\033[01;41m'
BG_LGREEN='\033[01;42m'
BG_LYELLOW='\033[01;43m'
BG_LBLUE='\033[01;44m'
BG_LPURPLE='\033[01;45m'
BG_LCYAN='\033[01;46m'
BG_WHITE='\033[01;47m'

#Reset background color to default
BK_NO_COLOR='\033[00;49m'

if [ $EUID == 0 ]; then
   export PS1="\[$FG_LRED\]\u\[$FG_LPURPLE\]@\[$FG_LCYAN\]\h \[$FG_LBLUE\]\W\$ \[$FG_NO_COLOR\]"
else
   export PS1="\[$FG_LGREEN\]\u\[$FG_LPURPLE\]@\[$FG_LCYAN\]\h \[$FG_LBLUE\]\W\$ \[$FG_NO_COLOR\]"
fi
