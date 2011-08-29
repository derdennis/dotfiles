# Dennis .bash_profile 
#
# Just set a path, greet the user and hand things over to .bashrc
#
# Notes: ----------------------------------------------------------
# When you start an interactive shell (log into the console, open terminal/xterm/iTerm, or create a new tab in iTerm) the following files are read and run, in this order:
# 
# /etc/profile
# /etc/bashrc
# ~/.bash_profile
# ~/.bashrc (Note: only if you call it in .bash_profile or somewhere else)
#
# When an interactive shell, that is not a login shell, is started (when you call "bash" from inside a login shell, or open a new tab in Linux) the following files are read and executed, in this order:
# 
# /etc/bashrc
# ~/.bashrc
# 
# via:
# http://blog.toddwerth.com/entries/4

# Path ------------------------------------------------------------

# uname output thingies from OS X 10.7:
#
#~ >  uname
#Darwin
#~ >  uname -a
#Darwin MacBookPro.local 11.1.0 Darwin Kernel Version 11.1.0: Tue Jul 26 16:07:11 PDT 2011; root:xnu-1699.22.81~1/RELEASE_X86_64 x86_64
#~ >  echo $OSTYPE
#darwin11
#
# uname output thingies from UbuntuVM (dokuWiki)
# ~ >  uname
# Linux
# ~ >  uname -a
# Linux dokuwiki 2.6.32-33-generic-pae #72-Ubuntu SMP Fri Jul 29 22:06:29 UTC 2011 i686 GNU/Linux
# ~ >  echo $OSTYPE
# linux-gnu
#

export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:/usr/local/git/bin/:$PATH  # OS-X Specific, with MacPorts, Git and MySQL installed
export PATH=/opt/local/bin:/opt/local/sbin:$PATH  # OS-X Specific, with MacPorts installed

# OS X specific for some self compiled stuff. ie upslug2 for installin nslu2...
export PATH=/usr/local/sbin:$PATH

if [ -d ~/bin ]; then
	export PATH=:~/bin:$PATH  # add your bin folder to the path, if you have it.  It's a good place to add all your scripts
fi

# Hello Messsage --------------------------------------------------
echo -e "Kernel Information: " `uname -smr`
#echo -e "${COLOR_BROWN}`bash --version`"
#echo -ne "${COLOR_GRAY}Uptime: "; uptime
#echo -ne "${COLOR_GRAY}Server time is: "; date
#echo -e "`bash --version`"
echo -ne "Uptime: "; uptime
echo -ne "Server time is: "; date

# Load in .bashrc -------------------------------------------------
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Setting PATH for Subversion 1.5.1 binaries
# The orginal version is saved in .bash_profile.svnsave
PATH="/opt/subversion/bin:${PATH}"
export PATH

##
# Your previous /Users/dennis/.bash_profile file was backed up as /Users/dennis/.bash_profile.macports-saved_2009-08-31_at_20:05:20
##

# MacPorts Installer addition on 2009-08-31_at_20:05:20: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

# Wiki shortcut for definitions
# via: http://onethingwell.org/post/2858158431/wikipedia-cli
wiki() {
        dig +short txt $1.wp.dg.cx
    }
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
