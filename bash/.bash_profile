# See following for more information: http://www.infinitered.com/blog/?p=19


# Path ------------------------------------------------------------
# export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:/usr/local/git/bin/:$PATH  # OS-X Specific, with MacPorts, Git and MySQL installed
#export PATH=/opt/local/bin:/opt/local/sbin:$PATH  # OS-X Specific, with MacPorts installed

# OS X specific for some self compiled stuff. ie upslug2 for installin nslu2...
# export PATH=/usr/local/sbin:$PATH

if [ -d ~/bin ]; then
	export PATH=:~/bin:$PATH  # add your bin folder to the path, if you have it.  It's a good place to add all your scripts
fi



# Load in .bashrc -------------------------------------------------
source ~/.bashrc



# Hello Messsage --------------------------------------------------
echo -e "Kernel Information: " `uname -smr`
#echo -e "${COLOR_BROWN}`bash --version`"
#echo -ne "${COLOR_GRAY}Uptime: "; uptime
#echo -ne "${COLOR_GRAY}Server time is: "; date
#echo -e "`bash --version`"
echo -ne "Uptime: "; uptime
echo -ne "Server time is: "; date

# History Magic ---------------------------------------------------
# append to the history file, don't overwrite it
shopt -s histappend

#Commit command to history file immedeately after execution
PROMPT_COMMAND="history -a"

# quite long bash history with date and time
export HISTTIMEFORMAT='%Y.%m.%d-%T :: ' HISTFILESIZE=50000 HISTSIZE=50000

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

# Notes: ----------------------------------------------------------
# When you start an interactive shell (log in, open terminal or iTerm in OS X, 
# or create a new tab in iTerm) the following files are read and run, in this order:
#     profile
#     bashrc
#     .bash_profile
#     .bashrc (only because this file is run (sourced) in .bash_profile)
#
# When an interactive shell, that is not a login shell, is started 
# (when you run "bash" from inside a shell, or when you start a shell in 
# xwindows [xterm/gnome-terminal/etc] ) the following files are read and executed, 
# in this order:
#     bashrc
#     .bashrc

