#!/bin/bash

# Check for some essential commands
# via: http://technotales.wordpress.com/2010/03/12/deps-what-am-i-missing/

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)

ATTR_RESET=$(tput sgr0)

# ok_failed(cmd, description)
ok_failed() {
  local cmd=$1
  local description=$2

  eval $cmd > /dev/null 2>&1

  if [ $? == 0 ]; then
    echo "[${GREEN}  OK  ${ATTR_RESET}]" $description
  else
    echo "[${RED}FAILED${ATTR_RESET}]" $description
  fi
}

# check_installed(prg_name, cmd_name=prg_name)
check_installed() {
  local prg_name=${1}
  local cmd_name=${2:-$1}

  ok_failed "which $cmd_name" $prg_name
}

check_installed vim
check_installed tmux
check_installed git
check_installed awk
check_installed sed
echo
check_installed ruby
check_installed gem
check_installed rake
echo

