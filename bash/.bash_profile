# Dennis .bash_profile 
#
# Just set a path, greet the user and hand things over to .bashrc
#
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
    'MINGW32_NT-5.1')
        platform='windows'
        ;;
esac

# Path ------------------------------------------------------------

case $platform in
    'macosx')
        # OS-X Specific, with MacPorts, Git and MySQL installed and some self compiled stuff. ie upslug2 for installin nslu2...
        export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:/usr/local/git/bin/:/usr/local/sbin:$PATH
        ;;
esac

# add your bin folder to the path, if you have it.  It's a good place to add all your scripts
if [ -d ~/bin ]; then
	export PATH=:~/bin:$PATH  
fi

# UTF-8 locale ----------------------------------------------------
export LANG=de:DE.UTF-8
export LC_ALL=de_DE.UTF-8

# Hello Messsage --------------------------------------------------
echo -e "Kernel Information: " `uname -smr`
#echo -e "${COLOR_BROWN}`bash --version`"
#echo -ne "${COLOR_GRAY}Uptime: "; uptime
#echo -ne "${COLOR_GRAY}Server time is: "; date
#echo -e "`bash --version`"
echo -ne "Uptime: "; uptime
echo -ne "Server time is: "; date
echo ""
case $platform in
    'linux')
        echo 'This is Linux'
        ;;
    'freebsd')
        echo 'This is FreeBSD'
        ;;
    'openbsd')
        echo 'This is OpenBSD'
        ;;
    'macosx')
        echo 'This is Mac OS X'
        ;;
    'windows')
        echo 'This is Windows'
        ;;
    *)
        echo 'Unknown platform'
        ;;
esac

# Load in .bashrc -------------------------------------------------
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi


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
