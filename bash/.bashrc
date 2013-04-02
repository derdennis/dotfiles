# See following for more information: http://www.infinitered.com/blog/?p=19

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Set a Variable to yes if we are on interactive
INTERACTIVETERM=-YES-
if [ "$TERM" == "" ]; then INTERACTIVETERM="-NO-"; TERM="vt100"; fi
if [ "$TERM" == "dumb" ]; then INTERACTIVETERM="-NO-"; TERM="vt100"; fi
export INTERACTIVETERM

# Detect platform by uname
# via: http://stackoverflow.com/questions/394230/detect-os-from-a-bash-script
platform='unknown'
unamestr=$(uname)

case $unamestr in
    'Linux')
        platform='linux'
        ;;
    'FreeBSD')
        platform='freebsd'
        ;;
    'OpenBSD')
        platform='openbsd'
        ;;
    'Darwin')
        platform='macosx'
        ;;
esac

# Grep Options ----------------------------------------------------

# Add color to greps output
GREP_OPTIONS='--color=auto'
# Use green instead of red
GREP_COLOR='1;32'
# If the grep supports it, exclude some version control dirs
if man grep | col -b | grep -- --exclude-dir &>/dev/null; then
    for PATTERN in .cvs .git .hg .svn; do
        GREP_OPTIONS="$GREP_OPTIONS --exclude-dir=$PATTERN"
    done
fi

export GREP_OPTIONS
export GREP_COLOR

# SSH Agent Magic located in the sshag.sh script in ~/bin/
if [ -f ~/bin/sshag.sh ]; then
    source ~/bin/sshag.sh
fi

# Colors ----------------------------------------------------------
export TERM=xterm-color

# Defining colors for Linux, OS X and BSDs...
#
# Good explanation:
# http://unix.stackexchange.com/questions/2897/clicolor-and-ls-colors-in-bash
case $platform in
    'linux')
        # Linux specific
        alias ls='ls --color'
        #ls colors, see: http://www.linux-sxs.org/housekeeping/lscolors.html
        LS_COLORS='di=34:fi=0:ln=32:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
        export LS_COLORS
        ;;
    'macosx')
        # OS X/*BSD specific - the -G command in OS X is for colors, in Linux it's no groups
        export CLICOLOR=1
        alias ls='ls -G'
        ;;
    'freebsd')
        export CLICOLOR=1
        alias ls='ls -G'
        ;;
    'openbsd')
        export CLICOLOR=1
        alias ls='ls -G'
        ;;
esac

# Setup some colors to use later in interactive shell or scripts
export COLOR_NC='\e[0m' # No Color
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GRAY='\e[1;30m'
export COLOR_LIGHT_GRAY='\e[0;37m'
alias colorslist="set | egrep 'COLOR_\w*'"  # Lists all the colors, uses vars in .bashrc_non-interactive

# Set up TPUT color codes
if [ "$INTERACTIVETERM" == "-YES-" ]; then
  tReset="$(tput sgr0)"
  tBold="$(tput bold)"
  tBlack="$(tput setaf 0)"
  tRed="$(tput setaf 1)"
  tGreen="$(tput setaf 2)"
  tYellow="$(tput setaf 3)"
  tBlue="$(tput setaf 4)"
  tPink="$(tput setaf 5)"
  tCyan="$(tput setaf 6)"
  tGray="$(tput setaf 7)"
  tWhite="$(tput setaf 8)"
  TUNON="$(tput smul)"
  TUNOFF="$(tput rmul)"
# Use the tRandcolor for a random color when sshing to other boxes like that:
# export PS1="\[${tRandColor}\]\u@\[${tBold}\]\h\[${tReset}\]:\[${tBlue}\]\w\[${tReset}\] \$ "
  tRandColor="$(tput setaf $(( $(hostname | openssl sha1 | sed 's/.*\([0-9]\).*/\1/') % 6 + 1 )) )"
else
  tReset=
  tBold=
  tBlack=
  tRed=
  tGreen=
  tYellow=
  tBlue=
  tPink=
  tCyan=
  tGray=
  tWhite=
  tUndOn=
  tUndOff=
  tRandColor=
fi

# Misc -------------------------------------------------------------
shopt -s checkwinsize # After each command, checks the windows size and changes lines and columns

# bash completion settings (actually, these are readline settings)
# Added here instead of maintaining ~/.inputrc
#
# When completing case will not be taken into consideration.
bind "set completion-ignore-case On"
# Apply similar insensitivity between hyphens and underscores
bind "set completion-map-case on"
# replace completed part with "...", so it's easy to see what to type next
bind "set completion-prefix-display-length 2"
# make Ctrl-j and Ctrl-k cycle through the available completions
bind "Control-j: menu-complete"
bind "Control-k: menu-complete-backward"
# show list automatically, without double tab
bind "set show-all-if-ambiguous On"
bind "set show-all-if-unmodified On"
# Do not show me possible completions page wise
bind "set page-completions off"
# Show me 1000 possible completions at a time
bind "set completion-query-items 1000"

# mappings for Ctrl-left-arrow and Ctrl-right-arrow for word moving Xterm Style
bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'
bind '"\e[5C": forward-word'
bind '"\e[5D": backward-word'
bind '"\e\e[C": forward-word'
bind '"\e\e[D": backward-word'
# PuTTY Style
bind '"\eOC":forward-word'
bind '"\eOD":backward-word'

# no bell
bind "set bell-style none"

# Turn off XON/XOFF flow control. If not Ctrl+S locks the terminal on many
# systems until it is resumed with Ctrl+Q. Thus, it is turned off here. Does not
# work in DTerm, so wrapped in an if statement...

if [[ "$TERM_PROGRAM" != "DTerm" ]]; then
    stty -ixon
fi

# Do not bell *at all* when on Linux.
case $platform in
    'linux')
    setterm -bfreq 0
    ;;
esac


# Turn on advanced bash completion if the file exists (Different incarnation
# for different platforms)

case $platform in
    'linux')
        if [ -f /etc/bash_completion ]; then
            . /etc/bash_completion
        fi
        ;;
   'macosx')
        if [ -f `brew --prefix`/etc/bash_completion ]; then
            . `brew --prefix`/etc/bash_completion
        fi
        ;;
esac


# Git completion for almost anything (remotes, branches, long forms...) via
# http://railsdog.com/blog/2009/03/07/custom-bash-prompt-for-git-branches/
# but needed the (obviously newer) file from:
# https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
fi

# alias git to g, saving me 66% on typing time! Also, I’m lazy.
alias g='git'
# Autocomplete for 'g' as well
complete -o default -o nospace -F _git g
# Get a funky commit message from whatthecommit.com...
alias gen_commit_message='curl http://whatthecommit.com/index.txt'

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

# Remove all git stuff from a project in CWD
alias ungit="find . -name '.git' -exec rm -rf {} \;"



# Rake task completion
# via: http://project.ioni.st/post/213#quote_213
complete -C ~/.rake-completion.rb -o default rake

# Ruby Version Management as a function
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Save me from performing UPDATE or DELETE operations on any table if neither
# a LIMIT nor a WHERE condition based on an indexed field is specified.
alias mysql='mysql --safe-updates'

# Wiki shortcut for definitions
# via: http://onethingwell.org/post/2858158431/wikipedia-cli
wiki() {
        dig +short txt $1.wp.dg.cx
    }


# find and list processes matching a case-insensitive partial-match string
fp () {
        ps -Ao pid,comm|awk '{match($0,/[^\/]+$/); print substr($0,RSTART,RLENGTH)": "$1}'|grep -i $1|grep -v grep
}

# find and kill processes matching a case-insensitive partial-match string
fk () {
    IFS=$'\n'
    PS3='Kill which process? (1 to cancel): '
    select OPT in "Cancel" $(fp $1); do
        if [ $OPT != "Cancel" ]; then
            kill $(echo $OPT|awk '{print $NF}')
        fi
        break
    done
    unset IFS
}

# OS X only: Edit Markdown File from Writing directory
# Finds Markdown files matching a Spotlight-style search query
# If there's more than one, you get a menu
case $platform in
    'macosx')
        edmd () {
            WRITINGDIR="~/Dropbox/Writing"
            EDITCMD="mate"
            filelist=$(mdfind -onlyin "$WRITINGDIR" "($@) AND kind:markdown")
            listlength=$(mdfind -onlyin "$WRITINGDIR" -count "($@) AND kind:markdown")
            if [[ $listlength > 0 ]]; then
                if [[ $listlength == 1 ]]; then
                    $EDITCMD $filelist
                else
                    IFS=$'\n'
                    PS3='Edit which file? (1 to cancel): '
                    select OPT in "Cancel" $filelist; do
                        if [ $OPT != "Cancel" ]; then
                            $EDITCMD $OPT
                        fi
                        break
                    done
                fi
            else
                return 1
            fi
            return 0
        }
        ;;
esac


# Prompts ----------------------------------------------------------
#export PS1="\[${COLOR_GREEN}\]\w > \[${COLOR_NC}\]"  # Primary prompt with only a path
# export PS1="\[${COLOR_GRAY}\]\u@\h \[${COLOR_GREEN}\]\w > \[${COLOR_NC}\]"  # Primary prompt with user, host, and path

# Primary prompt with only a path like above, but also showing git branches when
# inside a git repo. Also: Shows a yellow star when uncommited changes are found.
# Needed to express the colors with numerical values because the git prompt won't
# work with double quotes...
# Also: Shows the currently used Ruby- and Gemset-Version by using the rvm-prompt.
# RVM part via: http://collectiveidea.com/blog/archives/2011/08/02/command-line-feedback-from-rvm-and-git/?
# Check if the rvm-prompt binary is present before adding it to the prompt.
if [ -f  ~/.rvm/bin/rvm-prompt ];
then
    export PS1='\[\e[01;34m\]$(~/.rvm/bin/rvm-prompt) \[\e[0;32m\]\w > \[\e[0m\]$(__git_ps1 "[\[\e[0;32m\]%s\[\e[0m\]\[\e[0;33m\]$(parse_git_dirty)\[\e[0m\]]") '
else
    # If no rvm-prompt is present, do not include it in the prompt...
    export PS1='\[\e[0;32m\]\w > \[\e[0m\]$(__git_ps1 "[\[\e[0;32m\]%s\[\e[0m\]\[\e[0;33m\]$(parse_git_dirty)\[\e[0m\]]") '
fi



# This runs before the prompt and sets the title of the xterm* window.  If you set the title in the prompt
# weird wrapping errors occur on some systems, so this method is superior
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*} ${PWD}"; echo -ne "\007"'  # user@host path

export PS2='> '    # Secondary prompt
export PS3='#? '   # Prompt 3
export PS4='+'     # Prompt 4

function xtitle {  # change the title of your xterm* window
  unset PROMPT_COMMAND
  echo -ne "\033]0;$1\007"
}



# Navigation -------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'

# Correct things like dropped or swapped characters in the path you type
shopt -s cdspell

# Function to mkdir a whole tree and cd into it
mkcd () {
    mkdir -p "$*"
    cd "$*"
}

# Source the next action todo function if found in my homes bin folder
[[ -s "/Users/dennis/bin/na.sh" ]] && source "/Users/dennis/bin/na.sh"


# Source the handy CTRL-T completeme shortcut if it exists 
# via: https://pypi.python.org/pypi/completeme
[[ -s "/usr/local/bin/setup_completeme_key_binding.sh" ]] && source "/usr/local/bin/setup_completeme_key_binding.sh"

# Function to check if a command exists. Returns 0 if command is found, 1 if
# not
command_exists () {
    type "$1" &> /dev/null ;
}

# I got the following from, and mod'd it: http://www.macosxhints.com/article.php?story=20020716005123797
#    The following aliases (save & show) are for saving frequently used directories
#    You can save a directory using an abbreviation of your choosing. Eg. save ms
#    You can subsequently move to one of the saved directories by using cd with
#    the abbreviation you chose. Eg. cd ms  (Note that no '$' is necessary.)

# if .dirs doesn't exist, create it
if [ ! -f ~/.dirs ]; then
    touch ~/.dirs
fi

# Alias for showing the saved shortcuts
alias show='cat ~/.dirs'

# Function to save the current directory with a custom shortcut
save (){
	command sed "/$@/d" ~/.dirs > ~/.dirs1; \mv ~/.dirs1 ~/.dirs; echo "$@"=\"`pwd`\" >> ~/.dirs; source ~/.dirs ;
}

# Initialization for the above 'save' facility: source the .dirs file
source ~/.dirs

# set the bash option so that no '$' is required when using the above facility
shopt -s cdable_vars

# History Magic ---------------------------------------------------
# append to the history file, don't overwrite it
shopt -s histappend

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# quite long bash history with date and time
export HISTTIMEFORMAT='%Y.%m.%d-%T :: '

# Real big history
HISTSIZE=100000
HISTFILESIZE=100000

# no duplicates in history
export HISTCONTROL=ignoredups:ignorespace


# If you issue 'h' on its own, then it acts like the history command.
# If you issue:
# h cd
# Then it will display all the history with the word 'cd'
h() { if [ -z "$1" ]; then history; else history | grep "$@"; fi; }

# Search through History with the current entered starting point by pressing
# down or up arrow key
bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward

# Other aliases ----------------------------------------------------
alias ll='ls -ahlF'
alias la='ls -A'
alias lla='ls -lah'
alias l='ls -CF'
alias cl='clear; ls -lhG'
alias cla='clear; ls -lhAG'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias pg='ps axw | grep -i'

# Quickly ack all files, ignoring case
alias aa='ack -ai'

# Use pry instead of irb if available on the system
if command_exists pry ; then
    alias irb='pry'
fi

# Use fasd if available on the system
if command_exists fasd ; then
    eval "$(fasd --init auto)"
    # fasd default aliases
    alias a='fasd -a'        # any
    alias s='fasd -s'        # show / search / select
    alias d='fasd -d'        # directory
    alias f='fasd -f'        # file
    alias sd='fasd -sid'     # interactive directory selection
    alias sf='fasd -sif'     # interactive file selection
    alias z='fasd_cd -d'     # cd, same functionality as j in autojump
    alias zz='fasd_cd -d -i' # cd with interactive selection

    # fasd custom aliases
    alias v='f -e vim' # quick opening files with vim

fi

# Use extract function to simply extract all kind of archives with the same
# command. Via:
# http://alias.sh/extract-most-know-archives-one-command
extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# cf x test.txt xreates a file of x MB named test.txt
# Defaults to 10 MB and a name of upload_file.txt
# Via:
# http://alias.sh/create-arbiturary-size-file
cf() {
    upload_file="upload_file.txt"
    mbs=1048576

    if [ -n "$2" ]; then
        upload_file="$2"
    fi

    let size=`expr $mbs*$1`;
    dd if=/dev/zero of="$upload_file" bs=$size count=1
}

# Misc
alias ducks='du -cksh * | sort -rn|head -11' # Lists folders and files sizes in the current folder

# Mac OS X only aliases
case $platform in
    'macosx')
        alias top='top -o cpu'
        # Quick look a file (^C to close)
        alias ql='qlmanage -p 2>/dev/null'
        # pretty man pages in Preview.app
        function pman() {
        man $1 -t | open -f -a Preview
        }
    ;;
esac

# function to explore system.log on OS X and syslog on Linux
case $platform in
    'macosx')
        function systail () {
        if [[ $# > 0 ]]; then
            query=$(echo "$*"|tr -s ' ' '|')
            tail -f /var/log/system.log|grep -i --color=auto -E "$query"
        else
            tail -f /var/log/system.log
        fi
        }
    ;;
    'linux')
        function systail () {
        if [[ $# > 0 ]]; then
            query=$(echo "$*"|tr -s ' ' '|')
            tail -f /var/log/syslog|grep -i --color=auto -E "$query"
        else
            tail -f /var/log/syslog
        fi
        }
    ;;
esac


alias m='more'
alias df='df -h'
alias funfact="elinks -dump randomfunfacts.com | sed -n '/^| /p' | tr -d \|"
# Aliasing the ridiculous long path tho the jekyll binary
alias jekyll='/var/lib/gems/1.8/gems/jekyll-0.10.0/bin/jekyll'

# Shortcut to md5 on OS X
#alias md5sum='openssl md5'

# Make tmux work with the OS X clipboard and launchctl by using an OS
# X specific config file if running on a Mac
# In any case: Make tmux use 256 colors by exporting the according TERM
# variable and, for good measure use the -2 switch
if [[ "$platform" = "macosx" ]]; then
    alias tmux='TERM=screen-256color tmux -2 -f ~/.tmux-osx.conf'
else
    alias tmux='TERM=screen-256color tmux -2'
fi

# Use sssh in place of ssh to reconnect or start a new tmux or screen session
# on the remote side. Via:
# http://alias.sh/reconnect-or-start-tmux-or-screen-session-over-ssh
sssh (){ ssh -t "$1" 'tmux attach || tmux new || screen -DR'; }

# Get the current weather in Essen, Germany
alias weather='weatherman "Essen, Germany"'

# Be nice to your computer
alias please='sudo'

# Shows most used commands, cool script I got this from: http://lifehacker.com/software/how-to/turbocharge-your-terminal-274317.php
alias profileme="history | awk '{print \$4}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"

# List Network Connections
lsnet(){
        lsof -i  | awk '{printf("%-14s%-20s%s\n", $10, $1, $9)}' | sort
}

# Set Finder label color
label(){
  if [ $# -lt 2 ]; then
    echo "USAGE: label [0-7] file1 [file2] ..."
    echo "Sets the Finder label (color) for files"
    echo "Default colors:"
    echo " 0  No color"
    echo " 1  Orange"
    echo " 2  Red"
    echo " 3  Yellow"
    echo " 4  Blue"
    echo " 5  Purple"
    echo " 6  Green"
    echo " 7  Gray"
  else
    osascript - "$@" << EOF
    on run argv
        set labelIndex to (item 1 of argv as number)
        repeat with i from 2 to (count of argv)
          try
            tell application "Finder"
                set theFile to POSIX file (item i of argv) as alias
                set label index of theFile to labelIndex
            end tell
          on error
          end try
        end repeat
    end run
EOF
  fi
}
# Integrate OS X Finder with the Shell

# Open current dir in Finder
alias of='open -a Finder ./'

# cd to the path of the front Finder window
cdf() {
	target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
	if [ "$target" != "" ]; then
		cd "$target"; pwd
	else
		echo 'No Finder window found' >&2
	fi
}

# Quick way to rebuild the Launch Services database and get rid
# of duplicates in the Open With submenu.
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Editors ----------------------------------------------------------
export EDITOR='vim'  #Command line
export VIM_APP_DIR='/Applications'
# Alias vim to the MacVim flavour if we are on OS X and we got MacVim installed
case $platform in
    'macosx')
        if [[ -f /Applications/MacVim.app/Contents/MacOS/Vim ]]; then
            alias vim="/Applications/MacVim.app/Contents/MacOS/Vim"
        fi
        ;;
esac


# MiscMisc ---------------------------------------------------------

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Subversion & Diff ------------------------------------------------
export SV_USER='dennis'  # Change this to your username that you normally use on subversion (only if it is different from your logged in name)
export SVN_EDITOR='${EDITOR}'

alias svshowcommands="echo -e '${COLOR_BROWN}Available commands:
   ${COLOR_GREEN}sv
   ${COLOR_GREEN}sv${COLOR_NC}help
   ${COLOR_GREEN}sv${COLOR_NC}import    ${COLOR_GRAY}Example: import ~/projects/my_local_folder http://svn.foo.com/bar
   ${COLOR_GREEN}sv${COLOR_NC}checkout  ${COLOR_GRAY}Example: svcheckout http://svn.foo.com/bar
   ${COLOR_GREEN}sv${COLOR_NC}status
   ${COLOR_GREEN}sv${COLOR_NC}status${COLOR_GREEN}on${COLOR_NC}server
   ${COLOR_GREEN}sv${COLOR_NC}add       ${COLOR_GRAY}Example: svadd your_file
   ${COLOR_GREEN}sv${COLOR_NC}add${COLOR_GREEN}all${COLOR_NC}    ${COLOR_GRAY}Note: adds all files not in repository [recursively]
   ${COLOR_GREEN}sv${COLOR_NC}delete    ${COLOR_GRAY}Example: svdelete your_file
   ${COLOR_GREEN}sv${COLOR_NC}diff      ${COLOR_GRAY}Example: svdiff your_file
   ${COLOR_GREEN}sv${COLOR_NC}commit    ${COLOR_GRAY}Example: svcommit
   ${COLOR_GREEN}sv${COLOR_NC}update    ${COLOR_GRAY}Example: svupdate
   ${COLOR_GREEN}sv${COLOR_NC}get${COLOR_GREEN}info${COLOR_NC}   ${COLOR_GRAY}Example: svgetinfo your_file
   ${COLOR_GREEN}sv${COLOR_NC}blame     ${COLOR_GRAY}Example: svblame your_file
'"

alias sv='svn --username ${SV_USER}'
alias svimport='sv import'
alias svcheckout='sv checkout'
alias svstatus='sv status'
alias svupdate='sv update'
alias svstatusonserver='sv status --show-updates' # Show status here and on the server
alias svcommit='sv commit'
alias svadd='svn add'
alias svaddall='svn status | grep "^\?" | awk "{print \$2}" | xargs svn add'
alias svdelete='sv delete'
alias svhelp='svn help'
alias svblame='sv blame'

svgetinfo (){
 	sv info $@
	sv log $@
}

# You need to create fmdiff and fmresolve, which can be found at: http://ssel.vub.ac.be/ssel/internal:fmdiff
alias svdiff='sv diff --diff-cmd fmdiff' # OS-X SPECIFIC
# Use diff for command line diff, use fmdiff for gui diff, and svdiff for subversion diff
