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
        # OS-X Specific, with MacPorts, Git and MySQL installed and some self
        # compiled stuff. ie upslug2 for installin nslu2...
        export PATH=/usr/local/bin:/usr/local/mysql/bin:/usr/local/sbin:/Library/TeX/texbin:$PATH
        # Activate autojump
        [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
        ;;
esac

# add your bin folder to the path, if you have it.  It's a good place to add all
# your scripts
if [ -d ~/bin ]; then
	export PATH=:~/bin:$PATH
fi

# Add RVM to PATH for scripting if RVM is installed
if [ -d ~/.rvm/bin ]; then
    export PATH=$PATH:$HOME/.rvm/bin
fi

### Add path to the Heroku Toolbelt if it is installed
if [ -d /usr/local/heroku/bin ]; then
    export PATH="/usr/local/heroku/bin:$PATH"
fi

### Add path to the Homebrew OpenSSL version if it is installed
if [ -d /usr/local/opt/openssl/bin ]; then
    export PATH="/usr/local/opt/openssl/bin:$PATH"
fi
# UTF-8 locale ----------------------------------------------------
export LANG=de:DE.UTF-8
export LC_ALL=de_DE.UTF-8

# Hello Messsage --------------------------------------------------

# Don't greet me on DTerm...
if [[ "$TERM_PROGRAM" != "DTerm" ]]; then

    echo -e "Kernel Information: " `uname -smr`
    echo -ne "Uptime: "; uptime
    echo -ne "Server time is: "; date
    echo ""
    case $platform in
        'linux')
            # Execute archey if present in $PATH
            path_to_archey=$(which archey)
            if [ -x "$path_to_archey" ] ; then
                $path_to_archey
            else
                echo 'This is Linux'
            fi
            ;;
        'freebsd')
            # Execute archey if present in $PATH
            path_to_archey=$(which archey)
            if [ -x "$path_to_archey" ] ; then
                $path_to_archey
            else
                echo 'This is FreeBSD'
            fi
            ;;
        'openbsd')
            # Execute archey if present in $PATH
            path_to_archey=$(which archey)
            if [ -x "$path_to_archey" ] ; then
                $path_to_archey
            else
                echo 'This is OpenBSD'
            fi
            ;;
        'macosx')
            # Execute archey (with color option -c) if present in $PATH
            path_to_archey=$(which archey)
            if [ -x "$path_to_archey" ] ; then
                $path_to_archey -c
            else
                echo 'This is Mac OS X'
            fi
            ;;
        'windows')
            echo 'This is Windows'
            ;;
        *)
            echo 'Unknown platform'
            ;;
    esac

fi

# Initialize rbenv and pyenv --------------------------------------
if command -v rbenv 1>/dev/null 2>&1; then
    eval "$(rbenv init -)"
fi

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Load in .bashrc -------------------------------------------------
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Notes: ----------------------------------------------------------
# When you start an interactive shell (log into the console, open
# terminal/xterm/iTerm, or create a new tab in iTerm) the following files are
# read and run, in this order:
#
# /etc/profile
# /etc/bashrc
# ~/.bash_profile
# ~/.bashrc (Note: only if you call it in .bash_profile or somewhere else)
#
# When an interactive shell, that is not a login shell, is started (when you
# call "bash" from inside a login shell, or open a new tab in Linux) the
# following files are read and executed, in this order:
#
# /etc/bashrc
# ~/.bashrc
#
# via:
# http://blog.toddwerth.com/entries/4
