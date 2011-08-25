# See following for more information: http://www.infinitered.com/blog/?p=19

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

# Path ------------------------------------------------------------
# export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:/usr/local/git/bin/:$PATH  # OS-X Specific, with MacPorts, Git and MySQL installed
#export PATH=/opt/local/bin:/opt/local/sbin:$PATH  # OS-X Specific, with MacPorts installed

# OS X specific for some self compiled stuff. ie upslug2 for installin nslu2...
# export PATH=/usr/local/sbin:$PATH

if [ -d ~/bin ]; then
	export PATH=:~/bin:$PATH  # add your bin folder to the path, if you have it.  It's a good place to add all your scripts
fi



# Load in .bashrc -------------------------------------------------
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi



# Hello Messsage --------------------------------------------------
echo -e "Kernel Information: " `uname -smr`
#echo -e "${COLOR_BROWN}`bash --version`"
#echo -ne "${COLOR_GRAY}Uptime: "; uptime
#echo -ne "${COLOR_GRAY}Server time is: "; date
#echo -e "`bash --version`"
echo -ne "Uptime: "; uptime
echo -ne "Server time is: "; date


